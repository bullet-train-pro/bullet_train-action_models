class Scaffolding::ActionModelTransformer < Scaffolding::Transformer
  attr_accessor :action

  RUBY_NEW_ACTION_MODEL_BUTTONS_PROCESSING_HOOK = "<%# 🚅 super scaffolding will insert new action model buttons above this line. %>"
  RUBY_NEW_BULK_ACTION_MODEL_BUTTONS_PROCESSING_HOOK = "<%# 🚅 super scaffolding will insert new bulk action model buttons above this line. %>"
  RUBY_NEW_ACTION_MODEL_INDEX_VIEWS_PROCESSING_HOOK = "<%# 🚅 super scaffolding will insert new action model index views above this line. %>"

  def initialize(action, child, parents, cli_options = {})
    super(child, parents, cli_options)
    self.action = action
  end

  def action_model_class
    "#{child.pluralize}::#{action}Action"
  end

  def add_ability_line_to_roles_yml
    role_file = "./config/models/roles.yml"
    add_line_to_yml_file(role_file, "#{action_model_class}: read", [:default, :models])
    add_line_to_yml_file(role_file, "#{action_model_class}: manage", [:admin, :models])
  end

  def add_locale_helper_export_fix
    namespaced_locale_export_hook = "# 🚅 super scaffolding will insert the export for the locale view helper here."

    spacer = "  "
    indentation = spacer * 3
    namespace_elements = child.underscore.pluralize.split("/")
    first_element = namespace_elements.shift
    lines_to_add = [first_element + ":"]
    namespace_elements.map do |namespace_element|
      lines_to_add << indentation + namespace_element + ":"
      indentation += spacer
    end

    lines_to_add << transform_string("#{indentation}#{targets_n}_actions: *#{targets_n}_actions")

    scaffold_replace_line_in_file("./config/locales/en/scaffolding/completely_concrete/tangible_things/#{targets_n}_actions.en.yml", lines_to_add.join("\n"), namespaced_locale_export_hook)
  end

  def add_button_to_index
    # Add the bulk action button to the target _index partial
    target_index_file = "./app/views/account/scaffolding/completely_concrete/tangible_things/_index.html.erb"
    scaffold_add_line_to_file(
      target_index_file,
      "<%= render \"account/scaffolding/completely_concrete/tangible_things/#{targets_n}_actions/new_button_many\", absolutely_abstract_creative_concept: absolutely_abstract_creative_concept %>",
      RUBY_NEW_BULK_ACTION_MODEL_BUTTONS_PROCESSING_HOOK,
      prepend: true
    )
  end

  def add_index_to_parent
    target_index_file = "./app/views/account/scaffolding/completely_concrete/tangible_things/_index.html.erb"
    scaffold_add_line_to_file(
      target_index_file,
      "<%= render 'account/scaffolding/completely_concrete/tangible_things/#{targets_n}_actions/index', #{targets_n}_actions: context.completely_concrete_tangible_things_#{targets_n}_actions %>",
      RUBY_NEW_ACTION_MODEL_INDEX_VIEWS_PROCESSING_HOOK,
      prepend: true
    )
  end

  def add_button_to_index_rows
    # Add the action button to the target _index partial
    target_index_file = "./app/views/account/scaffolding/completely_concrete/tangible_things/_index.html.erb"
    scaffold_add_line_to_file(
      target_index_file,
      "<%= render \"account/scaffolding/completely_concrete/tangible_things/#{targets_n}_actions/new_button_one\", absolutely_abstract_creative_concept: absolutely_abstract_creative_concept, tangible_thing: tangible_thing %>",
      RUBY_NEW_ACTION_MODEL_BUTTONS_PROCESSING_HOOK,
      prepend: true
    )
  end

  def add_has_many_to_parent_model
    # Add the has_many to the parent model (not the target)
    scaffold_add_line_to_file(
      "./app/models/scaffolding/absolutely_abstract/creative_concept.rb",
      "has_many :completely_concrete_tangible_things_#{targets_n}_actions, class_name: \"Scaffolding::CompletelyConcrete::TangibleThings::#{targets_n.classify}Action\", dependent: :destroy, foreign_key: :absolutely_abstract_creative_concept_id, enable_updates: true, inverse_of: :absolutely_abstract_creative_concept",
      HAS_MANY_HOOK,
      prepend: true
    )
  end

  def scaffold_action_model
    files = [
      "./app/models/scaffolding/completely_concrete/tangible_things/#{targets_n}_action.rb",
      "./app/serializers/api/v1/scaffolding/completely_concrete/tangible_things/#{targets_n}_action_serializer.rb",
      "./app/controllers/api/v1/scaffolding/completely_concrete/tangible_things/#{targets_n}_actions_endpoint.rb",
      "./app/controllers/account/scaffolding/completely_concrete/tangible_things/#{targets_n}_actions_controller.rb",
      "./app/views/account/scaffolding/completely_concrete/tangible_things/#{targets_n}_actions",
      "./test/models/scaffolding/completely_concrete/tangible_things/#{targets_n}_action_test.rb",
      "./test/factories/scaffolding/completely_concrete/tangible_things/#{targets_n}_actions.rb",
      "./test/controllers/api/v1/scaffolding/completely_concrete/tangible_things/#{targets_n}_actions_endpoint_test.rb",
      "./config/locales/en/scaffolding/completely_concrete/tangible_things/#{targets_n}_actions.en.yml",
    ]

    files.each do |name|
      if File.directory?(resolve_template_path(name))
        scaffold_directory(name)
      else
        scaffold_file(name)
      end
    end

    add_locale_helper_export_fix

    add_button_to_index
    add_button_to_index_rows
    add_index_to_parent
    add_has_many_to_parent_model

    # TODO Is there a better way to do this without getting "No need to update './app/models/memberships/import_action.rb'. It already has ''."?
    scaffold_replace_line_in_file(
      "./app/models/scaffolding/completely_concrete/tangible_things/#{targets_n}_action.rb",
      "                             ",
      "has_one :team, through: :team"
    )

    # add user permissions.
    add_ability_line_to_roles_yml

    begin
      # Update the routes to add the namespace and action routes
      routes_manipulator = Scaffolding::RoutesFileManipulator.new("config/routes.rb", transform_string("Scaffolding::CompletelyConcrete::TangibleThings::#{targets_n.classify}Action"), transform_string("Scaffolding::AbsolutelyAbstract::CreativeConcept"))
      routes_manipulator.apply(["account"])
      # TODO We need this to also add `post :approve` to the resource block as well. Do we support that already?
      routes_manipulator.write
    rescue BulletTrain::SuperScaffolding::CannotFindParentResourceException => exception
      # TODO It would be great if we could automatically generate whatever the structure of the route needs to be and
      # tell them where to try and inject it. Obviously we can't calculate the line number, otherwise the robots would
      # have already inserted the routes, but at least we can try to do some of the complicated work for them.
      add_additional_step :red, "We were not able to generate the routes for your Action Model automatically because: \"#{exception.message}\" You'll need to add them manually, which admittedly can be complicated. See https://blog.bullettrain.co/nested-namespaced-rails-routing-examples/ for guidance. 🙇🏻‍♂️"
    end

    add_additional_step :yellow, "We've generated a new model and migration file for you, so make sure to run `rake db:migrate`."
  end
end