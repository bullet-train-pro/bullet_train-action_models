require "scaffolding/action_model_targets_one_parent_transformer"

module BulletTrain
  module ActionModels
    module Scaffolders
      class TargetsOneParentScaffolder < SuperScaffolding::Scaffolder
        def run
          unless argv.count >= 3
            puts ""
            puts "🚅  usage: bin/super-scaffold action-model:targets-one-parent <ActionModel> <TargetModel> <ParentModel[s]>"
            puts ""
            puts "E.g. a CSV Importer that creates many Listings on a Team:"
            puts "  # You do not need to `rails g model`, we'll create the models!"
            puts "  bin/super-scaffold action-model:targets-one-parent CsvImport Listing Team"
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

          transformer = Scaffolding::ActionModelTargetsOneParentTransformer.new(action_model, target_model, parent_models)
          transformer.check_namespace

          puts `yes n | bin/rails g model #{transformer.transform_string("Scaffolding::CompletelyConcrete::TangibleThings::TargetsOneParentAction")} #{transformer.transform_string("absolutely_abstract_creative_concept")}:references started_at:datetime completed_at:datetime target_count:integer performed_count:integer scheduled_for:datetime sidekiq_jid:string created_by:references approved_by:references`

          transformer.scaffold_action_model

          transformer.restart_server
        end
      end
    end
  end
end
