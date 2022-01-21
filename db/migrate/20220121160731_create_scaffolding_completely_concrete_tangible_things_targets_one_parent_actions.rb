class CreateScaffoldingCompletelyConcreteTangibleThingsTargetsOneParentActions < ActiveRecord::Migration[7.0]
  def change
    create_table :scaffolding_completely_concrete_tangible_things_targets_one_parent_actions do |t|
      t.references :absolutely_abstract_creative_concept, null: false, foreign_key: {to_table: "scaffolding_absolutely_abstract_creative_concepts"}, index: {name: "index_targets_one_parent_actions_on_creative_concept_id"}
      t.datetime :started_at
      t.datetime :completed_at
      t.integer :target_count
      t.integer :performed_count, default: 0
      t.datetime :scheduled_for
      t.string :sidekiq_jid
      t.references :created_by, null: false, foreign_key: {to_table: "memberships"}, index: {name: "index_targets_one_parents_on_created_by_id"}
      t.references :approved_by, null: true, foreign_key: {to_table: "memberships"}, index: {name: "index_targets_one_parents_on_approved_by_id"}

      t.timestamps
    end
  end
end
