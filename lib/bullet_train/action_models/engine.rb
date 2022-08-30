module BulletTrain
  module ActionModels
    class Engine < ::Rails::Engine
      initializer "bullet_train.super_scaffolding.action_models.templates.register_template_path" do |app|
        # Register the base path of this package with the Super Scaffolding engine.
        BulletTrain::SuperScaffolding.template_paths << File.expand_path("../../../..", __FILE__)
        BulletTrain::SuperScaffolding.scaffolders.merge!({
          "action-model:targets-many" => "BulletTrain::ActionModels::Scaffolders::TargetsManyScaffolder",
          "action-model:targets-one" => "BulletTrain::ActionModels::Scaffolders::TargetsOneScaffolder",
          "action-model:targets-one-parent" => "BulletTrain::ActionModels::Scaffolders::TargetsOneParentScaffolder",
          "action-model:performs-export" => "BulletTrain::ActionModels::Scaffolders::PerformsExportScaffolder",
          "action-model:performs-import" => "BulletTrain::ActionModels::Scaffolders::PerformsImportScaffolder",
        })
      end
    end
  end
end
