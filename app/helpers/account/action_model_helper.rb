module Account::ActionModelHelper
  def action_model_select_controller
    table_wrapper_attributes = {
      class: "bulk-actions",
      data: {
        controller: "bulk-actions",
        'bulk-actions-selectable-available-class': "selectable-available",
        'bulk-actions-selectable-class': "selectable",
        'bulk-actions-selectable-value': false
      }
    }

    tag.div class: "space-y-4 #{table_wrapper_attributes[:class]}", data: table_wrapper_attributes[:data] do
      yield
    end
  end

  def export_field_options(export_action)
    export_action.class::AVAILABLE_FIELDS.keys.map do |key|
      [key, t("#{export_action.subject}.fields.#{key}.heading")]
    end.to_h
  end
end
