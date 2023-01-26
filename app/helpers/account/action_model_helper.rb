module Account::ActionModelHelper
  def export_field_options(export_action)
    export_action.class::AVAILABLE_FIELDS.keys.map do |key|
      [key, t("#{export_action.subject}.fields.#{key}.heading")]
    end.to_h
  end

  def import_field_options(import_action)
    import_action.class::AVAILABLE_FIELDS.map do |key|
      [t("#{import_action.subject.klass.name.underscore.pluralize}.fields.#{key}.heading"), key]
    end
  end

  def import_label_with_time(import_action)
    "#{import_action.label_string} - Imported #{(time_ago_in_words(import_action.created_at))} ago"
  end
end
