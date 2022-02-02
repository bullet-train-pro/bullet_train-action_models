class Scaffolding::ActionModelTargetsManyTransformer < Scaffolding::Transformer
  attr_accessor :action

  def initialize(action, child, parents, cli_options = {})
    super(child, parents, cli_options)
    self.action = action
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

    lines_to_add << transform_string("#{indentation}targets_many_actions: *targets_many_actions")

    scaffold_replace_line_in_file("./config/locales/en/scaffolding/completely_concrete/tangible_things/targets_many_actions.en.yml", lines_to_add.join("\n"), namespaced_locale_export_hook)
  end

  RUBY_NEW_ACTION_MODEL_BUTTONS_PROCESSING_HOOK = "<%# 🚅 super scaffolding will insert new action model buttons above this line. %>"
  RUBY_NEW_BULK_ACTION_MODEL_BUTTONS_PROCESSING_HOOK = "<%# 🚅 super scaffolding will insert new bulk action model buttons above this line. %>"
  RUBY_NEW_ACTION_MODEL_INDEX_VIEWS_PROCESSING_HOOK = "<%# 🚅 super scaffolding will insert new action model index views above this line. %>"

  def scaffold_action_model
    files = [
      "./app/models/scaffolding/completely_concrete/tangible_things/targets_many_action.rb",
      "./app/serializers/api/v1/scaffolding/completely_concrete/tangible_things/targets_many_action_serializer.rb",
      "./app/controllers/api/v1/scaffolding/completely_concrete/tangible_things/targets_many_actions_endpoint.rb",
      "./app/controllers/account/scaffolding/completely_concrete/tangible_things/targets_many_actions_controller.rb",
      "./app/views/account/scaffolding/completely_concrete/tangible_things/targets_many_actions",
      "./test/models/scaffolding/completely_concrete/tangible_things/targets_many_action_test.rb",
      "./test/factories/scaffolding/completely_concrete/tangible_things/targets_many_actions.rb",
      "./test/controllers/api/v1/scaffolding/completely_concrete/tangible_things/targets_many_actions_endpoint_test.rb",
      "./config/locales/en/scaffolding/completely_concrete/tangible_things/targets_many_actions.en.yml",
    ]

    files.each do |name|
      if File.directory?(name)
        scaffold_directory(name)
      else
        scaffold_file(name)
      end
    end

    add_locale_helper_export_fix

    # Add the action button to the target _index partial
    target_index_file = "./app/views/account/scaffolding/completely_concrete/tangible_things/_index.html.erb"
    scaffold_add_line_to_file(
      target_index_file,
      "<%= render \"account/scaffolding/completely_concrete/tangible_things/targets_many_actions/new_button_one\", absolutely_abstract_creative_concept: absolutely_abstract_creative_concept, tangible_thing: tangible_thing %>",
      RUBY_NEW_ACTION_MODEL_BUTTONS_PROCESSING_HOOK,
      prepend: true
    )

    # Add the bulk action button to the target _index partial
    scaffold_add_line_to_file(
      target_index_file,
      "<%= render \"account/scaffolding/completely_concrete/tangible_things/targets_many_actions/new_button_many\", absolutely_abstract_creative_concept: absolutely_abstract_creative_concept %>",
      RUBY_NEW_BULK_ACTION_MODEL_BUTTONS_PROCESSING_HOOK,
      prepend: true
    )

    # Add the action index partial to the target _index partial
    scaffold_add_line_to_file(
      target_index_file,
      "<%= render 'account/scaffolding/completely_concrete/tangible_things/targets_many_actions/index', targets_many_actions: context.completely_concrete_tangible_things_targets_many_actions %>",
      RUBY_NEW_ACTION_MODEL_INDEX_VIEWS_PROCESSING_HOOK,
      prepend: true
    )

    # Add the has_many to the parent model (not the target)
    scaffold_add_line_to_file(
      "./app/models/scaffolding/absolutely_abstract/creative_concept.rb",
      "has_many :completely_concrete_tangible_things_targets_many_actions, class_name: \"Scaffolding::CompletelyConcrete::TangibleThings::TargetsManyAction\", dependent: :destroy, foreign_key: :absolutely_abstract_creative_concept_id, enable_updates: true, inverse_of: :absolutely_abstract_creative_concept",
      HAS_MANY_HOOK,
      prepend: true
    )

    # Update the ability file
    add_line_to_file("app/models/ability.rb", transform_string("Scaffolding::CompletelyConcrete::TangibleThings::TargetsManyAction,"), "# 🚅 add action models above.", prepend: true)
    # Update the ability file

    # Add the concern we have to add manually because otherwise it gets transformed.
    add_line_to_file(transform_string("app/models/scaffolding/completely_concrete/tangible_things/targets_many_action.rb"), "include Actions::TargetsMany", "include Actions::SupportsScheduling", prepend: true)

    # Restart the server to pick up the translation files
    restart_server

    # Update the routes to add the namespace and action routes
    routes_manipulator = Scaffolding::RoutesFileManipulator.new("config/routes.rb", transform_string("Scaffolding::CompletelyConcrete::TangibleThings::TargetsManyAction"), transform_string("Scaffolding::AbsolutelyAbstract::CreativeConcept"))
    routes_manipulator.apply(["account"])
    # TODO We need this to also add `post :approve` to the resource block as well. Do we support that already?
    routes_manipulator.write

    # TODO This is a hack. Replace with Adam's real version of this upstream.
    lines = File.read("config/routes.rb").lines.map(&:chomp)

    lines.each_with_index do |line, index|
      if line.include?(transform_string("resources :targets_many_actions"))
        lines[index] = "#{line} do\nmember do\npost :approve\nend\nend\n"
        break
      end
    end

    File.write("config/routes.rb", lines.join("\n"))

    puts `standardrb --fix ./config/routes.rb #{transform_string("./app/models/scaffolding/completely_concrete/tangible_things/targets_many_action.rb")}`

    add_additional_step :yellow, "We've generated a new model and migration file for you, so make sure to run `rake db:migrate`."

    additional_steps.each_with_index do |additional_step, index|
      color, message = additional_step
      puts ""
      puts "#{index + 1}. #{message}".send(color)
    end
    puts ""
  end

  def transform_string(string)
    string = super(string)

    [
      "Targets Many to",
      "append an emoji to",
      "TargetsMany",
      "targets_many",
      "Targets Many",
    ].each do |needle|
      # TODO There might be more to do here?
      # What method is this calling?
      string = string.gsub(needle, encode_double_replacement_fix(replacement_for(needle)))
    end
    decode_double_replacement_fix(string)
  end

  def replacement_for(string)
    case string
    # Some weird edge cases we unwittingly introduced in the emoji example.
    when "Targets Many to"
      # e.g. "Archive"
      # If someone wants language like "Targets Many to", they have to add it manually or name their model that.
      action.titlecase
    when "append an emoji to"
      # e.g. "archive"
      # If someone wants language like "append an emoji to", they have to add it manually.
      action.humanize
    when "TargetsMany"
      action
    when "targets_many"
      action.underscore
    when "Targets Many"
      action.titlecase
    else
      "🛑"
    end
  end
end
