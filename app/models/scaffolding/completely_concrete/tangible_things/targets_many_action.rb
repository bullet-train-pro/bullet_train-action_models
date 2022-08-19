class Scaffolding::CompletelyConcrete::TangibleThings::TargetsManyAction < ApplicationRecord
  # 🚅 skip this section when scaffolding.
  def self.table_name
    "sc_completely_concrete_tangible_things_targets_many_actions"
  end
  # 🚅 stop any skipping we're doing now.

  include Actions::TargetsMany # 🚅 skip when scaffolding.
  include Actions::ProcessesAsync
  # include Actions::SupportsScheduling
  include Actions::HasProgress
  include Actions::TracksCreator
  # include Actions::RequiresApproval
  # include Actions::CleansUp
  # 🚅 add concerns above.

  # 🚅 add attribute accessors above.

  belongs_to :absolutely_abstract_creative_concept, class_name: "Scaffolding::AbsolutelyAbstract::CreativeConcept"
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  # 🚅 skip this section when scaffolding.
  has_one :team, through: :absolutely_abstract_creative_concept
  # 🚅 stop any skipping we're doing now.
  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  # 🚅 skip this section when scaffolding.
  validates :emoji, presence: true
  # 🚅 stop any skipping we're doing now.
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def valid_targets
    absolutely_abstract_creative_concept.completely_concrete_tangible_things
  end

  # 🚅 skip this section when scaffolding.
  def emoji_label
    I18n.t("scaffolding/completely_concrete/tangible_things/targets_many_actions.fields.emoji.options.#{emoji}")
  end
  # 🚅 stop any skipping we're doing now.

  def perform_on_target(tangible_thing)
    # This is where you implement the operation you want to perform on each target.
    # 🚅 skip this section when scaffolding.
    # This is just an example option to help illustrate long-running jobs.
    # Unless we're just getting started, sleep 5 seconds between each targeted record.
    sleep delay

    tangible_thing.update(text_field_value: tangible_thing.text_field_value + " " + emoji_label)
    # 🚅 stop any skipping we're doing now.
  end

  # 🚅 add methods above.
end
