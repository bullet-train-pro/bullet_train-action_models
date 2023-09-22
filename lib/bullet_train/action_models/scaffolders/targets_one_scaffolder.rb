require "scaffolding/action_model_targets_one_transformer"

module BulletTrain
  module ActionModels
    module Scaffolders
      # TODO this method was removed from the global scope in super scaffolding and moved to `Scaffolding::Transformer`,
      # but this gem hasn't been updated yet.
      def legacy_replace_in_file(file, before, after)
        puts "Replacing in '#{file}'."
        target_file_content = File.read(file)
        target_file_content.gsub!(before, after)
        File.write(file, target_file_content)
      end

      class TargetsOneScaffolder < SuperScaffolding::Scaffolder
        def run
          unless argv.count >= 3
            puts ""
            puts "🚅  usage: bin/super-scaffold action-model:targets-one <ActionModel> <TargetModel> <ParentModel[s]>"
            puts ""
            puts "E.g. a schedulable Publish action for one Listing:"
            puts "  # You do not need to `rails g model`, we'll create the models!"
            puts "  bin/super-scaffold action-model:targets-one Publish Listing Team"
            puts ""
            puts "👋 After scaffolding your action model, you can add custom fields to it with the `crud-field` scaffolder, the same way you would a regular model."
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

          transformer = Scaffolding::ActionModelTargetsOneTransformer.new(action_model, target_model, parent_models)

          `yes n | bin/rails g model #{transformer.transform_string("Scaffolding::CompletelyConcrete::TangibleThings::TargetsOneAction")} #{transformer.transform_string("tangible_thing")}:references started_at:datetime completed_at:datetime target_count:integer performed_count:integer scheduled_for:datetime sidekiq_jid:string created_by:references approved_by:references`

          transformer.scaffold_action_model

          # # TODO I don't think we need this? Or we need something else?
          # # If the target model belongs directly to Team, we end up with delegate :team, to :team in the model file so we remove it here.
          # # We would need this for a deeply nested resource (I _think_??)
          # legacy_replace_in_file(transformer.transform_string("./app/models/scaffolding/completely_concrete/tangible_things/targets_one_action.rb"), "delegate :team, to: :team", "")

          transformer.restart_server
        end
      end
    end
  end
end
