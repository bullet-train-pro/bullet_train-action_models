require "csv"
require "roo"

module Actions::PerformsImport
  extend ActiveSupport::Concern
  include Actions::TargetsOne
  include Actions::HasProgress
  include Actions::TracksCreator
  include Actions::RequiresApproval

  PRIMARY_KEY_FIELD = :id
  BOM_CHARACTER = "\xEF\xBB\xBF"

  included do
    belongs_to :copy_mapping_from, class_name: name, optional: true
    has_many :mapping_copied_by, class_name: name, dependent: :nullify, foreign_key: :copy_mapping_from_id
    has_one_attached :file
    has_one_attached :rejected_file
    validates :copy_mapping_from, scope: true
    before_create :analyze_file
  end

  def analyze_file
    # Record the number of rows in this CSV.
    self.target_count = csv.length

    # Determine the default mapping of columns in the file to attributes of the target model.
    self.mapping = csv.headers.map do |key|
      mapped_field = if key.present?
        if copy_mapping_from&.mapping&.key?(key)
          # If the user specified another import to try and copy the mapping from,
          # check whether it has a mapping for the key in question, and if it does, use it.
          copy_mapping_from.mapping[key]
        elsif self.class::AVAILABLE_FIELDS.include?(key.to_sym)
          key
        end
      end

      [key, mapped_field]
    end.to_h
    puts file.filename
    tmp = Tempfile.new
    tmp.write(csv)
    file.attach(io: tmp.open, filename: "#{file.filename.base}.csv", content_type: "text/csv")
    puts file.filename
  end

  def csv
    # Because we need to analyze the file before it's saved we to use the `.attachment_changes` method to read the file.
    # This method is currently an undocumented feature in Rails so it might unexpectedly break in the future.
    # Docs: https://apidock.com/rails/v6.1.3.1/ActiveStorage/Attached/Model/attachment_changes
    # Discussion: https://github.com/rails/rails/pull/37005
    string = if attachment_changes["file"].present?
      if Rails.version.to_i < 7
        attachment = attachment_changes["file"].attachable
        parsed = Roo::Spreadsheet.open(attachment, {csv_options: {liberal_parsing: true}}).to_csv # earlier versions of ruby will blow up here, due to lack of liberal_parsing
        # see if we can remove the bom without gsub as the docs say
        parsed.gsub(BOM_CHARACTER.force_encoding(Encoding::BINARY), "")
        parsed.delete("\"") # The Roo::Spreadsheet.to_csv method above puts everything in double quotes, which we want to remove
      else
        attachment_changes["file"].attachment.download
      end
    else
      file.download
    end

    @csv ||= CSV.parse(string, headers: true)
  end

  def rejected_file_path
    "#{subject.klass.name.underscore.tr("/", "_")}-#{id}-failed.csv"
  end

  def rejected_file_tempfile
    @rejected_file_tempfile ||= Tempfile.new(rejected_file_path)
    @rejected_file_tempfile.binmode unless @rejected_file_tempfile.closed?
    @rejected_file_tempfile
  end

  def rejected_csv
    @rejected_csv ||= if rejected_file.attached?
      rejected_file_tempfile.write(rejected_file.download)
      CSV.new(rejected_file_tempfile)
      # We specifically don't rewind the file here because we're only opening it to continue writing to it.
    else
      CSV.new(rejected_file_tempfile, write_headers: true, headers: csv.headers + ["rejected_reason"])
    end
  end

  def calculate_target_count
    csv.length
  end

  def label_string
    file.filename.to_s
  end

  def mark_row_failed(row, reason)
    row["failure_reason"] = reason
    rejected_csv << row

    increment :failed_count
  end

  # TODO Comment what is going on here. Is there I reason I rewind the CSV handler in one place
  # and the raw file handler in another? Do we really need to `close` both the CSV and the tempfile?
  # Aren't they the same file?
  def close_rejected_csv
    rejected_csv.rewind
    if rejected_csv.read.count > 1
      rejected_file_tempfile.rewind
      rejected_file.attach(io: rejected_file_tempfile, filename: rejected_file_path, content_type: "text/csv")
    end

    rejected_csv.close
    rejected_file_tempfile.close
    rejected_file_tempfile.unlink
  end

  def after_page
    close_rejected_csv
  end

  def after_row_processed(target)
    increment :succeeded_count
  end

  def map_row(row)
    row.to_h.compact.map do |key, value|
      mapped_key = key.present? && mapping.fetch(key).presence
      mapped_key ? [mapped_key, value] : nil
    end.compact.to_h
  end

  def source_primary_key
    # TODO We originally had `@source_primary_key ||=`, but a bug was reported where removing it fixed the problem.
    # Would love to know what the issue was, but more important to get this working, so removing this.
    mapping.key(PRIMARY_KEY_FIELD.to_s)
  end

  def find_or_create_by_fields
    @find_or_create_by_fields ||= self.class::FIND_OR_CREATE_BY_FIELDS.map do |candidate|
      [candidate] unless candidate.is_a?(Array)
    end.detect do |candidate|
      # Return true if this import has a mapping to every one of the attributes in this set.
      candidate.reject { |key| mapping.key(key.to_s).present? }.empty?
    end&.map(&:to_s)
  end

  def update_target_with_row(target, row)
    # Try updating the target with a mapped version of the row.
    if target.update(map_row(row).except(PRIMARY_KEY_FIELD.to_s))
      after_row_processed(target)
    else
      mark_row_failed(row, target.errors.full_messages.to_sentence + ".")
    end
  end

  def create_target_from_row(subject, row)
    # Try creating the target with a mapped version of the row.
    if (target = subject.new(map_row(row).except(PRIMARY_KEY_FIELD.to_s))).save
      after_row_processed(target)
    else
      mark_row_failed(row, target.errors.full_messages.to_sentence + ".")
    end
  end

  def page_size
    100
  end

  # We overload this to remove the `before_start` and `after_completion` callbacks.
  def perform
    perform_on_target(targeted)
  end

  def first_dispatch?
    last_processed_row < 0
  end

  def perform_on_target(team)
    processed = 0

    if first_dispatch?
      before_start
    end

    csv.each_with_index do |row, index|
      # If this isn't our first page of processing, skip to the first row we haven't processed.
      next unless index > last_processed_row

      before_each

      # If the mapping maps a column to the primary key attribute and this row has a primary key supplied ..
      if source_primary_key && (subject_id = row[source_primary_key].presence)
        # If we're able to find the target by the primary key ID ..
        if (target = subject.find_by(PRIMARY_KEY_FIELD => subject_id))
          # Try to update it.
          update_target_with_row(target, row)
        else
          # Otherwise we have to mark the row as failed, because they thought it had a primary key ID.
          mark_row_failed(row, "Couldn't find #{subject.klass.name.humanize} with ID #{row[source_primary_key]}.")
        end
      # If the mapping maps one of the sets of attributes we can find or create by ..
      elsif find_or_create_by_fields.present?
        # Construct a where condition to try and find the target by those attributes.
        # e.g. {"name"=>"Testing"}
        where_clause = map_row(row).filter { |key, _| find_or_create_by_fields.include?(key) }

        # If we're able to find the target using those attributes ..
        if where_clause.present? && (target = subject.find_by(where_clause))
          # Try to update it.
          update_target_with_row(target, row)
        else
          # Otherwise, we should try to create it.
          create_target_from_row(subject, row)
        end
      # If we don't have a primary key or something we can search by ..
      else
        # Then we're for sure creating a new record.
        create_target_from_row(subject, row)
      end

      after_each

      # Mark this row as processed.
      update(last_processed_row: index)

      # Increase the count of rows we've processed on this page.
      processed += 1

      # If we've processed all the rows we want to on this page, dispatch this job again and break out of the loop.
      if processed >= page_size
        after_page
        return dispatch
      end
    end

    after_page
    after_completion
  end
end
