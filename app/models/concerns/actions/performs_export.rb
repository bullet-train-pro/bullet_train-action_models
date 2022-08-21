require 'csv'

module Actions::PerformsExport
  extend ActiveSupport::Concern
  include Actions::TargetsMany
  include Actions::HasProgress

  included do
    has_one_attached :file
    after_initialize :include_default_fields, unless: :persisted?
  end

  def subject
    valid_targets.arel_table.name
  end

  def export_file_path
    subject.underscore.gsub("/", "_")
  end

  def before_start
    super
    @tempfile = Tempfile.new("#{export_file_path}.#{id}.csv")
    @csv = CSV.new(@tempfile)
    @csv << fields
  end

  def after_completion
    @tempfile.rewind
    file.attach(io: @tempfile, filename: "#{export_file_path}.csv", content_type: "text/csv")
    @csv.close
    @tempfile.close
    @tempfile.unlink
    super
  end

  def perform_on_target(project)
    @csv << fields.map do |field|
      value_for_field(project, field)
    end
  end

  # This is a template method that can be overloaded to control the way certain columns are exported.
  def value_for_field(project, field)
    project.send(field)
  end

  def include_default_fields
    return true if fields && fields.any?
    self.fields = self.class::AVAILABLE_FIELDS.select { |_, value| value }.keys
  end

  def label_string
    if target_all?
      "Export of all #{subject.titleize}"
    elsif target_ids.one?
      "Export of #{targeted.first.label_string}"
    else
      "Export of #{target_ids.count} #{subject.titleize.pluralize(target_ids.count)}"
    end
  end
end
