FactoryBot.define do
  factory :scaffolding_completely_concrete_tangible_things_targets_many_action, class: "Scaffolding::CompletelyConcrete::TangibleThings::TargetsManyAction" do
    association :absolutely_abstract_creative_concept, factory: :scaffolding_absolutely_abstract_creative_concept
    emoji { "MyString" }
    scheduled_for { "2021-08-31 20:37:40" }
    started_at { "2021-08-31 20:37:40" }
    completed_at { "2021-08-31 20:37:40" }
    # This is really important, otherwise you'll introduce a `delay` into your test suite.
    delay { 0 }
  end
end
