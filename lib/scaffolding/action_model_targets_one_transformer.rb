require_relative "transformer"
require_relative "block_manipulator"

class Scaffolding::ActionModelTargetsOneTransformer < Scaffolding::Transformer
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
    add_parent_model_action_model_hooks

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
      "<%= render 'account/scaffolding/completely_concrete/tangible_things/targets_many_actions/index', targets_many_actions: context.completely_concrete_tangible_things_targets_many_actions, hide_back: true %>",
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
    ability_transformer = Scaffolding::Transformer.new(transform_string("Scaffolding::CompletelyConcrete::TangibleThings::TargetsManyAction"), parents)
    ability_line_one = ability_transformer.build_ability_line(actions: "[:create, :read, :destroy]")[0]
    ability_line_two = ability_transformer.build_ability_line(actions: "[:update]")[0] + ", started_at: nil, approved_by_id: nil"
    ability_line_three = ability_transformer.build_ability_line(actions: "[:approve]")[0] + ", started_at: nil, approved_by_id: nil"
    ability_file = "./app/models/ability.rb"
    ability_hook = "# the following abilities were added by super scaffolding."
    add_line_to_file(ability_file, ability_line_three, ability_hook)
    add_line_to_file(ability_file, ability_line_two, ability_hook)
    add_line_to_file(ability_file, ability_line_one, ability_hook)
    add_line_to_file(ability_file, transform_string("# The following are the permissions for the Scaffolding::CompletelyConcrete::TangibleThing TargetsMany Action"), ability_hook)

    # Restart the server to pick up the translation files
    restart_server

    # Update the routes to add the namespace and action routes
    routes_manipulator = Scaffolding::RoutesFileManipulator.new("config/routes.rb", transform_string("Scaffolding::CompletelyConcrete::TangibleThings::TargetsManyAction"), transform_string("Scaffolding::AbsolutelyAbstract::CreativeConcept"))
    routes_manipulator.apply(["account"])
    # TODO We need this to also add `post :approve` to the resource block as well. Do we support that already?
    routes_manipulator.write

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

  #
  # This method adds the hooks to the parent model class if they don't already exist
  # This could happen if someone scaffolds some initial models using the base version of Bullet Train, then they
  # upgrade to the action_models extension.  If that happens, we need to add the action_model hooks in manually.
  #
  def add_parent_model_action_model_hooks
    index_file = transform_string "./app/views/account/scaffolding/completely_concrete/tangible_things/_index.html.erb"
    return if File.read(index_file).include?("<%= action_model_select_controller do %>")
    block_manipulator = Scaffolding::BlockManipulator.new(index_file)
    block_manipulator.wrap_block(starting: "<%= updates_for context, collection", with: ["<%= action_model_select_controller do %>", "<% end %>"])
    block_manipulator.insert('  <%= render "shared/tables/select_all" %>', within: transform_string("<% if tangible_things.any?"), after: "<tr>")
    block_manipulator.insert(transform_string('  <%= render "shared/tables/checkbox", object: tangible_thing %>'), within: transform_string("<% with_attribute_settings object: tangible_thing"), after: "<tr")
    block_manipulator.insert("<%# 🚅 super scaffolding will insert new bulk action model buttons above this line. %>", after_block: transform_string("<% if context == absolutely_abstract_creative_concept"))
    block_manipulator.insert("<%# 🚅 super scaffolding will insert new action model buttons above this line. %>", after_block: transform_string("<% if can? :destroy, tangible_thing"))
    block_manipulator.insert_block(["<% p.content_for :raw_footer do %>", "<% end %>"], after_block: "<% p.content_for :actions do")
    block_manipulator.insert("  <%# 🚅 super scaffolding will insert new action model index views above this line. %>", within: "<% p.content_for :raw_footer do")
    block_manipulator.write
  end
end
