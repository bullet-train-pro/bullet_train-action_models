require "scaffolding/action_model_performs_export_transformer"

module BulletTrain
  module ActionModels
    module Scaffolders
      class PerformsExportScaffolder < SuperScaffolding::Scaffolder
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
            puts "🚅  usage: bin/super-scaffold action-model:performs-export <ActionModel> <TargetModel> <ParentModel[s]>"
            puts ""
            puts "E.g. an Export action for Projects on a Team:"
            puts "  # You do not need to `rails g model`, we'll create the models!"
            puts "  bin/super-scaffold action-model:performs-export Export Project Team"
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

          transformer = Scaffolding::ActionModelPerformsExportTransformer.new(action_model, target_model, parent_models)

          `yes n | bin/rails g model #{transformer.transform_string("Scaffolding::CompletelyConcrete::TangibleThings::PerformsExportAction")} #{transformer.transform_string("absolutely_abstract_creative_concept")}:references target_all:boolean target_ids:#{Scaffolding.mysql? ? "json" : "jsonb"} failed_ids:#{Scaffolding.mysql? ? "json" : "jsonb"} last_completed_id:integer started_at:datetime completed_at:datetime target_count:integer performed_count:integer scheduled_for:datetime sidekiq_jid:string created_by:references{polymorphic} approved_by:references{polymorphic} fields:#{Scaffolding.mysql? ? "json" : "jsonb"}`

          transformer.scaffold_action_model
          transformer.fix_json_column_default("target_ids")
          transformer.fix_json_column_default("failed_ids")
          transformer.fix_json_column_default("fields")

          # If the target model belongs directly to Team, we end up with delegate :team, to :team in the model file so we remove it here.
          # We would need this for a deeply nested resource (I _think_??)
          legacy_replace_in_file(transformer.transform_string("./app/models/scaffolding/completely_concrete/tangible_things/performs_export_action.rb"), "delegate :team, to: :team", "")

          transformer.restart_server
        end
      end
    end
  end
end
