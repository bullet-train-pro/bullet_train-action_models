require "masamune"

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
    "#{import_action.label_string} - Imported #{time_ago_in_words(import_action.created_at)} ago"
  end

  # We can get the URL for most actions by passing [:account, action],
  # but we need a little more manpower to take care of deeply nested actions.
  # This helper ensures we get the right objects and path name for the action we're using.
  def build_action_model_path(action, type: nil)
    url_for([:account, action])
  rescue NoMethodError
    class_names = action.class.name.split("::")
    object_arguments = []

    # Check each namespace part and get the object if necessary.
    path_parts = class_names.map do |class_name|
      if action.respond_to?("#{class_name.underscore.singularize}_id".to_sym)
        klass = class_name.singularize.constantize
        attribute_id = action.send("#{class_name.underscore.singularize}_id".to_sym)
        object_arguments << klass.find(attribute_id)
        class_name.underscore.singularize
      else
        class_name.underscore
      end
    end
    path_parts.unshift(:account)

    # TODO: We might not need this like (or type: :collection altogether), just keeping it here for reference.
    (type == :collection) ? path_parts[-1] = path_parts[-1].pluralize : object_arguments << action

    # Build the path
    path_method = "#{"edit_" if type == :edit}#{path_parts.join("_")}_path"
    send(path_method, *object_arguments)
  end
end
