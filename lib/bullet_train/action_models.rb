require "bullet_train/action_models/version"
require "bullet_train/action_models/engine"
require "scaffolding"
require "scaffolding/transformer"
require "scaffolding/block_manipulator"
require "bullet_train/action_models/scaffolders/prepare_scaffolder"
require "bullet_train/action_models/scaffolders/performs_export_scaffolder"
require "bullet_train/action_models/scaffolders/performs_import_scaffolder"
require "bullet_train/action_models/scaffolders/targets_many_scaffolder"
require "bullet_train/action_models/scaffolders/targets_one_scaffolder"
require "bullet_train/action_models/scaffolders/targets_one_parent_scaffolder"

module BulletTrain
  module ActionModels
    mattr_accessor :health_check_worker, default: true
  end
end
