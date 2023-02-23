class Scaffolding::CompletelyConcrete::TangibleThings::PerformsImportAction < ApplicationRecord
  include Actions::PerformsImport # 🚅 skip when scaffolding.
  include Actions::ProcessesAsync
  # 🚅 add concerns above.

  belongs_to :absolutely_abstract_creative_concept, class_name: "Scaffolding::AbsolutelyAbstract::CreativeConcept"
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  has_one :team, through: :absolutely_abstract_creative_concept
  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def targeted
    absolutely_abstract_creative_concept
  end

  def subject
    targeted.completely_concrete_tangible_things
  end

  def valid_copy_mapping_froms
    absolutely_abstract_creative_concept.completely_concrete_tangible_things_performs_import_actions
  end

  # 🚅 add methods above.

  FIND_OR_CREATE_BY_FIELDS = [
    # 🚅 skip this section when scaffolding.
    :text_field_value
    # 🚅 stop any skipping we're doing now.
  ]

  AVAILABLE_FIELDS = [
    :id,
    # 🚅 skip this section when scaffolding.
    :text_field_value,
    :button_value,
    # 🚅 stop any skipping we're doing now.
    # 🚅 super scaffolding will insert new fields above this line.
    :created_at,
    :updated_at,
  ]
end
