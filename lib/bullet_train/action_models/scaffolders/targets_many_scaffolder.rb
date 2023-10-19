require "scaffolding/action_model_targets_many_transformer"

module BulletTrain
  module ActionModels
    module Scaffolders
      class TargetsManyScaffolder < SuperScaffolding::Scaffolder
        def run
          unless argv.count >= 3
            puts ""
            puts "🚅  usage: bin/super-scaffold action-model:targets-many <ActionModel> <TargetModel> <ParentModel[s]>"
            puts ""
            puts "E.g. an Archive action for Projects on a Team:"
            puts "  # You do not need to `rails g model`, we'll create the models!"
            puts "  bin/super-scaffold action-model:targets-many Archive Project Team"
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
          # action_model += "Action" unless action_model.match?(/Action$/)
          parent_models = parent_models.split(",")
          parent_models += ["Team"]
          parent_models = parent_models.map(&:classify).uniq

          transformer = Scaffolding::ActionModelTargetsManyTransformer.new(action_model, target_model, parent_models)
          transformer.check_namespace

          `yes n | bin/rails g model #{transformer.transform_string("Scaffolding::CompletelyConcrete::TangibleThings::TargetsManyAction")} #{transformer.transform_string("absolutely_abstract_creative_concept")}:references target_all:boolean target_ids:#{Scaffolding.mysql? ? "json" : "jsonb"} failed_ids:#{Scaffolding.mysql? ? "json" : "jsonb"} last_completed_id:integer started_at:datetime completed_at:datetime target_count:integer performed_count:integer scheduled_for:datetime sidekiq_jid:string created_by:references approved_by:references`

          transformer.scaffold_action_model
          transformer.fix_json_column_default("target_ids")
          transformer.fix_json_column_default("failed_ids")
          transformer.restart_server
        end
      end
    end
  end
end
