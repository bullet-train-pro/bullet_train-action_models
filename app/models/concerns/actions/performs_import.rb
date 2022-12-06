require "csv"

module Actions::PerformsImport
  extend ActiveSupport::Concern
  include Actions::TargetsOne
  include Actions::HasProgress
  include Actions::TracksCreator
  include Actions::RequiresApproval

  PRIMARY_KEY_FIELD = :id

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
      mapped_field = if key.present? && self.class::AVAILABLE_FIELDS.include?(key.to_sym)
        # If the user specified another import to try and copy the mapping from,
        # check whether it has a mapping for the key in question, and if it does, use it.
        if copy_mapping_from&.mapping&.key?(key)
          copy_mapping_from.mapping[key]
        else
          key
        end
      end

      [key, mapped_field]
    end.to_h
  end

  def csv
    # Because we need to analyze the file before it's saved we to use the `.attachment_changes` method to read the file.
    # This method is currently an undocumented feature in Rails so it might unexpectedly break in the future.
    # Docs: https://apidock.com/rails/v6.1.3.1/ActiveStorage/Attached/Model/attachment_changes
    # Discussion: https://github.com/rails/rails/pull/37005
    string = if self.attachment_changes['file'].present?
      self.attachment_changes['file'].attachable.read
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
  end

  def rejected_csv
    @rejected_csv ||= CSV.new(rejected_file_tempfile, write_headers: true, headers: csv.headers)
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

  def after_completion
    rejected_csv.rewind
    if rejected_csv.read.count > 1
      rejected_file_tempfile.rewind
      rejected_file.attach(io: rejected_file_tempfile, filename: rejected_file_path, content_type: "text/csv")
    end

    rejected_csv.close
    rejected_file_tempfile.close
    rejected_file_tempfile.unlink

    super
  end

  def mark_row_processed(row)
    increment :succeeded_count
  end

  def map_row(row)
    row.to_h.compact.map do |key, value|
      mapped_key = mapping.fetch(key).presence
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
      mark_row_processed(row)
    else
      mark_row_failed(row, target.errors.full_messages.to_sentence + ".")
    end
  end

  def create_target_from_row(subject, row)
    # Try creating the target with a mapped version of the row.
    if (target = subject.new(map_row(row).except(PRIMARY_KEY_FIELD.to_s))).save
      mark_row_processed(row)
    else
      mark_row_failed(row, target.errors.full_messages.to_sentence + ".")
    end
  end

  def perform_on_target(team)
    csv.each do |row|
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
      elsif find_or_create_by_fields
        # Construct a where condition to try and find the target by those attributes.
        # e.g. {"name"=>"Testing"}
        where_clause = map_row(row).filter { |key, _| find_or_create_by_fields.include?(key) }

        # If we're able to find the target using those attributes ..
        if (target = subject.find_by(where_clause))
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
    end
  end
end
