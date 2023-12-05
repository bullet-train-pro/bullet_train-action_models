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
    Dir["{app,config,db,lib}/**/*", "test/controllers/**/*", "test/models/scaffolding/**/*", "test/factories/scaffolding/**/*", "LICENSE", "Rakefile", "README.md", ".bt-link"]
  end

  spec.add_dependency "rails", ">= 6.0.0"
  spec.add_dependency "matrix"
  spec.add_dependency "roo"
  spec.add_dependency "bullet_train"
  spec.add_dependency "bullet_train-super_scaffolding"
  # TODO: This is here because the main `bullet_train` gem needs it, but doesn't declare the dependency
  spec.add_dependency "bullet_train-fields"

  spec.add_development_dependency "standardrb"

  spec.license = "Nonstandard"
end
