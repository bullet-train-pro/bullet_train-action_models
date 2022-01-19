class Api::V1::Scaffolding::CompletelyConcrete::TangibleThings::TargetsOneActionSerializer < Api::V1::ApplicationSerializer
  set_type "scaffolding/completely_concrete/tangible_things/targets_one_action"

  attributes :id,
    :tangible_thing_id,
    :keep_receipt,
    :target_count,
    :performed_count,
    :created_by,
    :approved_by,
    :scheduled_for,
    :started_at,
    :completed_at,
    :delay,
    :emoji,
    # 🚅 super scaffolding will insert new fields above this line.
    :created_at,
    :updated_at

  belongs_to :tangible_thing, serializer: Api::V1::Scaffolding::CompletelyConcrete::TangibleThingSerializer
end
