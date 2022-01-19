class CreateScaffoldingCompletelyConcreteTangibleThingsTargetsOneActions < ActiveRecord::Migration[7.0]
  def change
    create_table :sc_completely_concrete_tangible_things_targets_one_actions do |t|
      t.references :tangible_thing, null: false, foreign_key: {to_table: "tangible_thing"}
      t.boolean :keep_receipt, default: true
      t.integer :target_count
      t.integer :performed_count, default: 0
      t.references :created_by, null: false, foreign_key: {to_table: "memberships"}, index: {name: "index_targets_ones_on_created_by_id"}
      t.references :approved_by, null: true, foreign_key: {to_table: "memberships"}, index: {name: "index_targets_ones_on_approved_by_id"}
      t.datetime :scheduled_for
      t.datetime :started_at
      t.datetime :completed_at
      t.string :sidekiq_jid
      t.integer :delay

      t.timestamps
    end
  end
end
