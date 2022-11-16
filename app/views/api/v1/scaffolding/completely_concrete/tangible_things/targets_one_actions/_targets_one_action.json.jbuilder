json.extract! targets_one_action,
  :id,
  :tangible_thing_id,
  :target_count,
  :performed_count,
  :created_by,
  :approved_by_id,
  :scheduled_for,
  :started_at,
  :completed_at,
  # 🚅 super scaffolding will insert new fields above this line.
  :created_at,
  :updated_at
json.url account_scaffolding_completely_concrete_tangible_things_targets_one_action_url(targets_one_action, format: :json)
