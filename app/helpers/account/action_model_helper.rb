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

  def build_action_model_path(request, action, type: nil)
    url_for([:account, action])
  rescue NoMethodError
    routes_file = File.read("config/routes.rb")
    msmn = Masamune::AbstractSyntaxTree.new(routes_file)
    resources = msmn.method_calls(token_value: "resources")
    namespaces = msmn.method_calls(token_value: "namespace")
    routes_keys = (resources + namespaces).map do |route|
      route.arguments.slice.split(",").first.gsub(/^:/, "")
    end

    action_model_parts = action.class.name.split("::")
    path_parts = request.path_info.split("/").reject(&:empty?)

    action_model_path = path_parts.map do |part|
      camelized_part = part.capitalize.camelize

      if !routes_keys.include?(part)
        # Skip when the part is an ID
      elsif !action_model_parts.include?(camelized_part)
        # If it's a part of the path but not an ID or in
        # the Action Model namespace, just return it as is.
        # i.e. - :account
        part.to_sym
      else
        idx = path_parts.index(part)

        # If the next part in the path is an ID, return the object.
        # This is a likely a resource. Return the object.
        # TODO: compensate for `nil` at end of path.
        if !routes_keys.include?(path_parts[idx + 1])
          klass = camelized_part.singularize.safe_constantize
          klass.nil? ? part.to_sym : klass.find(path_parts[idx + 1])
        else
          # This is a namespace. Return as is.
          part.to_sym
        end
      end
    end.compact

    object_arguments = action_model_path.reject { |part| part.is_a?(Symbol) } << action
    new_path_parts = action_model_path.map do |part|
      part.is_a?(Symbol) ? part.to_s : part.class.name.underscore
    end

    # Add each part of the action to the end if it's not already there.
    action_model_parts.each do |part|
      underscored_argument_classes = object_arguments.map { |arg| arg.class.name.underscore }
      unless new_path_parts.include?(part.underscore.singularize) || new_path_parts.include?(part.underscore.pluralize)
        new_path_parts << if underscored_argument_classes.include?(part.underscore)
          part.underscore.singularize
        else
          part.underscore
        end
      end
    end

    # Ensure the path is singular for non-collection actions.
    if object_arguments.last == action
      new_path_parts[-1] = new_path_parts.last.singularize
    end

    # Finally, return the path method.
    # i.e. - account_action_name_path(targeted_object, action)
    path_method = "#{"edit_" if type == :edit}#{new_path_parts.join("_")}_path".to_sym
    send(path_method, *object_arguments)
  end
end
