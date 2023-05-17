class CreateScaffoldingCompletelyConcreteTangibleThingsPerformsExportActions < ActiveRecord::Migration[7.0]
  def change
    create_table :sc_completely_concrete_tangible_things_performs_export_actions do |t|
      t.references :absolutely_abstract_creative_concept, null: false, foreign_key: {to_table: "scaffolding_absolutely_abstract_creative_concepts"}, index: {name: "index_tangible_things_export_on_creative_concept_id"}
      t.boolean :target_all, default: false
      t.jsonb :target_ids, default: []
      t.bigint :target_count
      t.bigint :performed_count, default: 0
      t.string :error_message
      t.references :created_by, null: true, foreign_key: {to_table: "memberships"}, index: {name: "index_append_emoji_actions_on_created_by_id"}
      t.references :approved_by, null: true, foreign_key: {to_table: "memberships"}, index: {name: "index_append_emoji_actions_on_approved_by_id"}
      t.datetime :scheduled_for
      t.datetime :started_at
      t.datetime :completed_at
      t.string :sidekiq_jid

      t.timestamps
    end
  end
end
