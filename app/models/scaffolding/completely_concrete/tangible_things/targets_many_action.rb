class Scaffolding::CompletelyConcrete::TangibleThings::TargetsManyAction < ApplicationRecord
  # 🚅 skip this section when scaffolding.
  def self.table_name
    "sc_completely_concrete_tangible_things_targets_many_actions"
  end

  # 🚅 stop any skipping we're doing now.
  include Actions::TargetsMany
  include Actions::SupportsScheduling
  include Actions::HasProgress
  include Actions::TracksCreator
  include Actions::SupportsApproval
  # 🚅 add concerns above.

  belongs_to :absolutely_abstract_creative_concept, class_name: "Scaffolding::AbsolutelyAbstract::CreativeConcept"
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  has_one :team, through: :absolutely_abstract_creative_concept
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

  def label_string
    "Targets Many Action"
  end

  # This is the actual operation we want to perform on each targeted object.
  def perform_on_target(tangible_thing)
    # This is just an example option to help illustrate long-running jobs.
    # Unless we're just getting started, sleep 5 seconds between each targeted record.
    sleep delay

    tangible_thing.update(text_field_value: tangible_thing.text_field_value + " " + emoji_label)
  end

  # 🚅 add methods above.
end
