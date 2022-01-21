class Scaffolding::CompletelyConcrete::TangibleThings::TargetsOneParentAction < ApplicationRecord
  # 🚅 skip this section when scaffolding.
  def self.table_name
    "sc_co_concrete_tangible_things_targets_one_parent_actions"
  end
  # 🚅 stop any skipping we're doing now.

  include Actions::TargetsOne
  include Actions::SupportsScheduling
  include Actions::HasProgress
  include Actions::TracksCreator
  include Actions::RequiresApproval
  include Actions::CleansUp
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

  def label_string
    "Targets One Parent Action"
  end

  def perform_on_target(absolutely_abstract_creative_concept)
    # This is where you implement the operation you want to perform on each target.
  end

  # 🚅 add methods above.
end
