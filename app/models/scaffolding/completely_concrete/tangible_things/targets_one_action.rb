class Scaffolding::CompletelyConcrete::TangibleThings::TargetsOneAction < ApplicationRecord
  # 🚅 skip this section when scaffolding.
  def self.table_name
    "sc_completely_concrete_tangible_things_targets_one_actions"
  end
  # 🚅 stop any skipping we're doing now.

  include Actions::TargetsOne # 🚅 skip when scaffolding.
  include Actions::SupportsScheduling
  include Actions::HasProgress
  include Actions::TracksCreator
  include Actions::RequiresApproval
  include Actions::CleansUp
  # 🚅 add concerns above.

  belongs_to :tangible_thing, class_name: "Scaffolding::CompletelyConcrete::TangibleThing"
  # 🚅 add belongs_to associations above.

  # 🚅 add has_many associations above.

  has_one :team, through: :tangible_thing
  # 🚅 add has_one associations above.

  # 🚅 add scopes above.

  # 🚅 skip this section when scaffolding.
  validates :emoji, presence: true
  # 🚅 stop any skipping we're doing now.
  # 🚅 add validations above.

  # 🚅 add callbacks above.

  # 🚅 add delegations above.

  def targeted
    tangible_thing
  end

  # 🚅 skip this section when scaffolding.
  def emoji_label
    I18n.t("scaffolding/completely_concrete/tangible_things/targets_one_actions.fields.emoji.options.#{emoji}")
  end
  # 🚅 stop any skipping we're doing now.

  def label_string
    "Targets One Action"
  end

  def calculate_target_count
    # 🚅 skip this section when scaffolding.
    return 3
    # 🚅 stop any skipping we're doing now.

    # This is where you calculate the total number of items that are going to be processed.
    1
  end

  def perform_on_target(tangible_thing)
    # 🚅 skip this section when scaffolding.
    3.times do
      before_each
      sleep delay
      tangible_thing.update(text_field_value: tangible_thing.text_field_value + " " + emoji_label)
      after_each
    end

    nil
    # 🚅 stop any skipping we're doing now.

    # This is where you implement the operation you want to perform on the action's target.
  end

  # 🚅 add methods above.
end
