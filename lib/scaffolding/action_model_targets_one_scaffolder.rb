require_relative "action_model_targets_one_transformer"

module ActionModelTargetsOneScaffolder
  def display_action_model_targets_one_help
    puts ""
    puts "🚅  usage: bin/super-scaffold action-model:targets-one <ActionModel> <TargetModel> <ParentModel[s]>"
    puts ""
    puts "E.g. a schedulable Publish action for one Listing:"
    puts "  # You do not need to `rails g model`, we'll create the models!"
    puts "  bin/super-scaffold action-model:targets-one Publish Listing"
    puts ""
    puts "E.g. a CSV Importer that creates many Listings on a Team:"
    puts "  # You do not need to `rails g model`, we'll create the models!"
    puts "  bin/super-scaffold action-model:targets-one CsvImport Listing Team"
    puts ""
    puts "👋 After scaffolding your action model, you can add custom fields to it with the `crud-field` scaffolder, the same way you would a regular model."
    puts ""
    standard_protip
    puts ""
    puts "Give it a shot! Let us know if you have any trouble with it! ✌️"
    puts ""
    exit
  end

  def scaffold_action_model_targets_one(args)
    action_model, target_model = args

    # E.g. `bin/super-scaffold action-model:targets-one Publish Listing`
    parent_models ||= "ShouldNotOccur"

    parent_models = parent_models.split(",")
    parent_models += ["Team"]
    parent_models = parent_models.map(&:classify).uniq

    transformer = Scaffolding::ActionModelTargetsOneTransformer.new(action_model, target_model, parent_models)

    output = `bin/rails g model #{transformer.transform_string("Scaffolding::CompletelyConcrete::TangibleThings::TargetsOneAction")} #{transformer.transform_string("tangible_thing")}:references started_at:datetime completed_at:datetime target_count:integer performed_count:integer scheduled_for:datetime sidekiq_jid:string created_by:references approved_by:references`

    # TODO I think this matches `identical` files from namespace generation, meaning it shows up 100% of the time you're
    # scaffolding into an existing namespace.
    # if output.include?("conflict") || output.include?("identical")
    #   puts "\n👆 No problem! Looks like you're re-running this Super Scaffolding command. We can work with the model already generated!\n".green
    # end

    migration_file_name = `grep "create_table :#{transformer.transform_string("scaffolding_completely_concrete_tangible_things_targets_one_actions")} do |t|" db/migrate/*`.split(":").first

    legacy_replace_in_file(migration_file_name, "t.references :tangible_thing, null: false, foreign_key: true", "t.references :tangible_thing, null: false, foreign_key: {to_table: \"scaffolding_completely_concrete_tangible_things\"}")
    legacy_replace_in_file(migration_file_name, "t.integer :performed_count", "t.integer :performed_count, default: 0")

    created_by_index_name = transformer.transform_string("index_scaffolding_completely_concrete_tangible_things_#{action_model.pluralize.underscore.downcase}_on_created_by_id")
    created_by_index_name = "index_#{action_model.pluralize.underscore.downcase}_on_created_by_id" if created_by_index_name.length > 63
    legacy_replace_in_file(migration_file_name, "t.references :created_by, null: false, foreign_key: true", "t.references :created_by, null: false, foreign_key: {to_table: \"memberships\"}, index: {name: \"#{created_by_index_name}\"}")

    approved_by_index_name = transformer.transform_string("index_scaffolding_completely_concrete_tangible_things_#{action_model.pluralize.underscore.downcase}_on_approved_by_id")
    approved_by_index_name = "index_#{action_model.pluralize.underscore.downcase}_on_approved_by_id" if approved_by_index_name.length > 63
    legacy_replace_in_file(migration_file_name, "t.references :approved_by, null: false, foreign_key: true", "t.references :approved_by, null: true, foreign_key: {to_table: \"memberships\"}, index: {name: \"#{approved_by_index_name}\"}")

    transformer.scaffold_action_model

    # # TODO I don't think we need this? Or we need something else?
    # # If the target model belongs directly to Team, we end up with delegate :team, to :team in the model file so we remove it here.
    # # We would need this for a deeply nested resource (I _think_??)
    # legacy_replace_in_file(transformer.transform_string("./app/models/scaffolding/completely_concrete/tangible_things/targets_one_action.rb"), "delegate :team, to: :team", "")

    transformer.restart_server
  end
end
