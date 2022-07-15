class Scaffolding::CompletelyConcrete::TangibleThings::PerformsExportAction < ApplicationRecord
  # 🚅 skip this section when scaffolding.
  def self.table_name
    "sc_completely_concrete_tangible_things_targets_many_actions"
  end
  # 🚅 stop any skipping we're doing now.

  include Actions::ProcessesAsync
  include Actions::TracksCreator
  include Actions::PerformsExport # 🚅 skip when scaffolding.
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

  def valid_targets
    absolutely_abstract_creative_concept.completely_concrete_tangible_things
  end

  # 🚅 add methods above.

  AVAILABLE_FIELDS = {
    # 🚅 skip this section when scaffolding.
    text_field_value: true,
    button_value: false,
    # 🚅 stop any skipping we're doing now.
    # 🚅 super scaffolding will insert new fields above this line.
    created_at: false,
    updated_at: false,
  }
end
