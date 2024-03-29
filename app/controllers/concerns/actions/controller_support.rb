module Actions::ControllerSupport
  extend ActiveSupport::Concern

  def assign_mapping(strong_params, subject, attribute)
    strong_params[attribute] = subject.send(attribute).keys.map do |key|
      [key, params[subject.class.name.underscore.tr("/", "_")]["mapping_#{key.underscore}"]]
    end.to_h
  end
end
