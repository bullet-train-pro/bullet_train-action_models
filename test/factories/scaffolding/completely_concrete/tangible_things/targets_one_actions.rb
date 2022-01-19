FactoryBot.define do
  factory :scaffolding_completely_concrete_tangible_things_targets_one_action, class: "Scaffolding::CompletelyConcrete::TangibleThings::TargetsOneAction" do
    association :absolutely_abstract_creative_concept, factory: :scaffolding_absolutely_abstract_creative_concept
    target_all { false }
    target_ids { "" }
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
