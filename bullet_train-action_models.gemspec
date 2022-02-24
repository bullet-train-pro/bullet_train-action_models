require_relative "lib/bullet_train/action_models/version"

Gem::Specification.new do |spec|
  spec.name = "bullet_train-action_models"
  spec.version = BulletTrain::ActionModels::VERSION
  spec.authors = ["Andrew Culver"]
  spec.email = ["andrew.culver@gmail.com"]
  spec.homepage = "https://github.com/andrewculver/bullet_train-action_models"
  spec.summary = "Bullet Train Action Models"
  spec.description = spec.summary

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the "allowed_push_host"
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  spec.metadata["allowed_push_host"] = "TODO: Set to 'http://mygemserver.com'"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  # spec.metadata["changelog_uri"] = "TODO: Put your gem's CHANGELOG.md URL here."

  spec.files = Dir.chdir(File.expand_path(__dir__)) do
    Dir["{app,config,db,lib}/**/*", "test/models/scaffolding/**/*", "test/factories/scaffolding/**/*", "test/controllers/api/v1/scaffolding/**/*", "LICENSE", "Rakefile", "README.md"]
  end

  spec.add_dependency "rails", ">= 6.0.0"
end
