require_relative "action_model_targets_many_transformer"

module ActionModelTargetsManyScaffolder
  def display_action_model_targets_many_help
    puts ""
    puts "🚅  usage: bin/super-scaffold action-model:targets-many <ActionModel> <TargetModel> <ParentModel[s]>"
    puts ""
    puts "E.g. an Archive action for Projects on a Team:"
    puts "  # You do not need to `rails g model`, we'll create the models!"
    puts "  bin/super-scaffold action-model Archive Project Team"
    puts ""
    puts "Also: After scaffolding your action model, you can add custom fields to it the same way you would a regular model."
    puts ""
    standard_protip
    puts ""
    puts "Give it a shot! Let us know if you have any trouble with it! ✌️"
    puts ""
    exit
  end

  def scaffold_action_model_targets_many(args)
    action_model, target_model, parent_models = args
    # action_model += "Action" unless action_model.match?(/Action$/)
    parent_models = parent_models.split(",")
    parent_models += ["Team"]
    parent_models = parent_models.map(&:classify).uniq

    transformer = Scaffolding::ActionModelTargetsManyTransformer.new(action_model, target_model, parent_models)

    output = `bin/rails g model #{transformer.transform_string("Scaffolding::CompletelyConcrete::TangibleThings::TargetsManyAction")} #{transformer.transform_string("absolutely_abstract_creative_concept")}:references target_all:boolean target_ids:jsonb started_at:datetime completed_at:datetime target_count:integer performed_count:integer scheduled_for:datetime sidekiq_jid:string created_by:references approved_by:references`

    if output.include?("conflict") || output.include?("identical")
      puts "\n👆 No problem! Looks like you're re-running this Super Scaffolding command. We can work with the model already generated!\n".green
    end

    migration_file_name = `grep "create_table :#{transformer.transform_string("scaffolding_completely_concrete_tangible_things_targets_many_actions")} do |t|" db/migrate/*`.split(":").first

    legacy_replace_in_file(migration_file_name, "t.references :absolutely_abstract_creative_concept, null: false, foreign_key: true", "t.references :absolutely_abstract_creative_concept, null: false, foreign_key: {to_table: \"scaffolding_absolutely_abstract_creative_concepts\"}")
    legacy_replace_in_file(migration_file_name, "t.boolean :target_all", "t.boolean :target_all, default: false")
    legacy_replace_in_file(migration_file_name, "t.jsonb :target_ids", "t.jsonb :target_ids, default: []")
    legacy_replace_in_file(migration_file_name, "t.integer :performed_count", "t.integer :performed_count, default: 0")

    created_by_index_name = transformer.transform_string("index_scaffolding_completely_concrete_tangible_things_#{action_model.pluralize.underscore.downcase}_on_created_by_id")
    created_by_index_name = "index_#{action_model.pluralize.underscore.downcase}_on_created_by_id" if created_by_index_name.length > 63
    legacy_replace_in_file(migration_file_name, "t.references :created_by, null: false, foreign_key: true", "t.references :created_by, null: false, foreign_key: {to_table: \"memberships\"}, index: {name: \"#{created_by_index_name}\"}")

    approved_by_index_name = transformer.transform_string("index_scaffolding_completely_concrete_tangible_things_#{action_model.pluralize.underscore.downcase}_on_approved_by_id")
    approved_by_index_name = "index_#{action_model.pluralize.underscore.downcase}_on_approved_by_id" if approved_by_index_name.length > 63
    legacy_replace_in_file(migration_file_name, "t.references :approved_by, null: false, foreign_key: true", "t.references :approved_by, null: true, foreign_key: {to_table: \"memberships\"}, index: {name: \"#{approved_by_index_name}\"}")

    transformer.scaffold_action_model

    # If the target model belongs directly to Team, we end up with delegate :team, to :team in the model file so we remove it here.
    # We would need this for a deeply nested resource (I _think_??)
    legacy_replace_in_file(transformer.transform_string("./app/models/scaffolding/completely_concrete/tangible_things/targets_many_action.rb"), "delegate :team, to: :team", "")

    transformer.restart_server
  end
end
