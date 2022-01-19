FactoryBot.define do
  factory :scaffolding_completely_concrete_tangible_things_targets_one_action, class: "Scaffolding::CompletelyConcrete::TangibleThings::TargetsOneAction" do
    association :tangible_thing, factory: :scaffolding_completely_concrete_tangible_thing
    emoji { "MyString" }
    keep_receipt { false }
    target_count { "" }
    performed_count { "" }
    created_by { nil }
    approved_by { nil }
    scheduled_for { "2021-08-31 20:37:40" }
    started_at { "2021-08-31 20:37:40" }
    completed_at { "2021-08-31 20:37:40" }
  end
end
