class Api::V1::Scaffolding::CompletelyConcrete::TangibleThings::TargetsManyActionSerializer < Api::V1::ApplicationSerializer
  set_type "scaffolding/completely_concrete/tangible_things/targets_many_action"

  attributes :id,
    :absolutely_abstract_creative_concept_id,
    :target_all,
    :target_ids,
    :emoji,
    :keep_receipt,
    :target_count,
    :performed_count,
    :created_by_id,
    :approved_by_id,
    :scheduled_for,
    :started_at,
    :completed_at,
    :delay,
    # 🚅 super scaffolding will insert new fields above this line.
    :created_at,
    :updated_at

  belongs_to :absolutely_abstract_creative_concept, serializer: Api::V1::Scaffolding::AbsolutelyAbstract::CreativeConceptSerializer
end
