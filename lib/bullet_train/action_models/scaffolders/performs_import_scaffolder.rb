require "scaffolding/action_model_performs_import_transformer"

module BulletTrain
  module ActionModels
    module Scaffolders
      class PerformsImportScaffolder < SuperScaffolding::Scaffolder
        # TODO these methods were removed from the global scope in super scaffolding and moved to `Scaffolding::Transformer`,
        # but this gem hasn't been updated yet.

        def legacy_replace_in_file(file, before, after)
          puts "Replacing in '#{file}'."
          target_file_content = File.open(file).read
          target_file_content.gsub!(before, after)
          File.open(file, "w+") do |f|
            f.write(target_file_content)
          end
        end

        def run
          unless argv.count >= 3
            puts ""
            puts "🚅  usage: bin/super-scaffold action-model:performs-import <ActionModel> <TargetModel> <ParentModel[s]>"
            puts ""
            puts "E.g. an Import action for Projects on a Team:"
            puts "  # You do not need to `rails g model`, we'll create the models!"
            puts "  bin/super-scaffold action-model:performs-import Import Project Team"
            puts ""
            puts "Also: After scaffolding your action model, you can add custom fields to it the same way you would a regular model."
            puts ""
            standard_protip
            puts ""
            puts "Give it a shot! Let us know if you have any trouble with it! ✌️"
            puts ""
            exit
          end

          action_model, target_model, parent_models = argv
          parent_models = parent_models.split(",")
          parent_models += ["Team"]
          parent_models = parent_models.map(&:classify).uniq

          transformer = Scaffolding::ActionModelPerformsImportTransformer.new(action_model, target_model, parent_models)

          `yes n | bin/rails g model #{transformer.transform_string("Scaffolding::CompletelyConcrete::TangibleThings::PerformsImportAction")} #{transformer.transform_string("absolutely_abstract_creative_concept")}:references target_all:boolean target_ids:#{Scaffolding.mysql? ? "json" : "jsonb"} started_at:datetime completed_at:datetime target_count:integer performed_count:integer scheduled_for:datetime sidekiq_jid:string created_by:references{polymorphic} approved_by:references{polymorphic} mapping:#{Scaffolding.mysql? ? "json" : "jsonb"} copy_mapping_from:references succeeded_count:integer failed_count:integer last_processed_row:integer`

          copy_mapping_from_index_name = transformer.transform_string("index_scaffolding_completely_concrete_tangible_things_#{action_model.pluralize.underscore.downcase}_on_copy_mapping_from_id")
          copy_mapping_from_index_name = "index_#{action_model.pluralize.underscore.downcase}_on_copy_mapping_from_id" if copy_mapping_from_index_name.length > 63
          legacy_replace_in_file(transformer.migration_file_name, "t.references :copy_mapping_from, null: false, foreign_key: true", "t.references :copy_mapping_from, null: true, foreign_key: {to_table: \"#{transformer.transform_string("scaffolding_completely_concrete_tangible_things_performs_import_actions")}\"}, index: {name: \"#{copy_mapping_from_index_name}\"}")

          transformer.scaffold_action_model
          transformer.fix_json_column_default("mapping", "{}")
          transformer.restart_server
        end
      end
    end
  end
end
