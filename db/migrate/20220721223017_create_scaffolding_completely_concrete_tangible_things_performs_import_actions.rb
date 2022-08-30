class CreateScaffoldingCompletelyConcreteTangibleThingsPerformsImportActions < ActiveRecord::Migration[7.0]
  def change
    create_table :scaffolding_completely_concrete_tangible_things_performs_import_actions do |t|
      t.references :absolutely_abstract_creative_concept, null: false, foreign_key: {to_table: "scaffolding_absolutely_abstract_creative_concepts"}, index: {name: "index_performs_import_actions_on_abstract_creative_concept_id"}
      t.datetime :started_at
      t.datetime :completed_at
      t.integer :target_count
      t.integer :performed_count, default: 0
      t.datetime :scheduled_for
      t.string :sidekiq_jid
      t.jsonb :mapping, default: []
      t.references :copy_mapping_from, null: true, foreign_key: {to_table: "scaffolding_completely_concrete_tangible_things_performs_import_actions"}, index: {name: "index_performs_imports_on_copy_mapping_from_id"}
      t.integer :succeeded_count, default: 0
      t.integer :failed_count, default: 0
      t.references :created_by, null: false, foreign_key: {to_table: "memberships"}, index: {name: "index_performs_imports_on_created_by_id"}
      t.references :approved_by, null: true, foreign_key: {to_table: "memberships"}, index: {name: "index_performs_imports_on_approved_by_id"}

      t.timestamps
    end
  end
end
