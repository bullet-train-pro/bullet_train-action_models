require "scaffolding/action_model_transformer"

class Scaffolding::ActionModelPerformsExportTransformer < Scaffolding::ActionModelTransformer
  def targets_n
    "performs_export"
  end

  def add_button_to_index_rows
  end

  def add_ability_line_to_roles_yml
    role_file = "./config/models/roles.yml"
    Scaffolding::FileManipulator.add_line_to_yml_file(role_file, "#{action_model_class}: read", [:default, :models])
    Scaffolding::FileManipulator.add_line_to_yml_file(role_file, "#{action_model_class}:\n      - read\n      - create\n      - destroy", [:admin, :models])
  end

  def scaffold_action_model
    super

    # Add the bulk action button to the target _index partial
    target_index_file = "./app/views/account/scaffolding/completely_concrete/tangible_things/_index.html.erb"
    scaffold_add_line_to_file(
      target_index_file,
      "<%= render \"account/scaffolding/completely_concrete/tangible_things/#{targets_n}_actions/new_button_many\", absolutely_abstract_creative_concept: absolutely_abstract_creative_concept %>",
      RUBY_NEW_BULK_ACTION_MODEL_BUTTONS_PROCESSING_HOOK,
      prepend: true
    )

    # Add the action index partial to the target _index partial
    scaffold_add_line_to_file(
      target_index_file,
      "<%= render 'account/scaffolding/completely_concrete/tangible_things/#{targets_n}_actions/index', #{targets_n}_actions: context.completely_concrete_tangible_things_#{targets_n}_actions %>",
      RUBY_NEW_ACTION_MODEL_INDEX_VIEWS_PROCESSING_HOOK,
      prepend: true
    )

    # Add the has_many to the parent model (not the target)
    scaffold_add_line_to_file(
      "./app/models/scaffolding/absolutely_abstract/creative_concept.rb",
      "has_many :completely_concrete_tangible_things_#{targets_n}_actions, class_name: \"Scaffolding::CompletelyConcrete::TangibleThings::PerformsExportAction\", dependent: :destroy, foreign_key: :absolutely_abstract_creative_concept_id, enable_updates: true, inverse_of: :absolutely_abstract_creative_concept",
      HAS_MANY_HOOK,
      prepend: true
    )

    # Add the concern we have to add manually because otherwise it gets transformed.
    add_line_to_file(transform_string("app/models/scaffolding/completely_concrete/tangible_things/#{targets_n}_action.rb"), "include Actions::PerformsExport", "include Actions::ProcessesAsync", prepend: true)

    # Add current attributes of the target model to the export options.
    (child.constantize.new.attributes.keys - ["created_at", "updated_at"]).each do |attribute|
      add_line_to_file(transform_string("app/models/scaffolding/completely_concrete/tangible_things/#{targets_n}_action.rb"), "#{attribute}: #{attribute == transform_string('absolutely_abstract_creative_concept_id') ? 'false' : 'true' },", RUBY_NEW_FIELDS_HOOK, prepend: true)
    end

    # Restart the server to pick up the translation files
    restart_server

    lines = File.read("config/routes.rb").lines.map(&:chomp)

    lines.each_with_index do |line, index|
      if line.include?(transform_string("resources :#{targets_n}_actions"))
        lines[index] = "#{line} do\nmember do\npost :approve\nend\nend\n"
        break
      end
    end

    File.write("config/routes.rb", lines.join("\n"))

    puts `standardrb --fix ./config/routes.rb #{transform_string("./app/models/scaffolding/completely_concrete/tangible_things/#{targets_n}_action.rb")}`

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
      "Performs Export to",
      "append an emoji to",
      "PerformsExport",
      "performs_export",
      "Performs Export",
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
    when "Performs Export to"
      # e.g. "Archive"
      # If someone wants language like "Targets Many to", they have to add it manually or name their model that.
      action.titlecase
    when "append an emoji to"
      # e.g. "archive"
      # If someone wants language like "append an emoji to", they have to add it manually.
      action.humanize
    when "PerformsExport"
      action
    when "performs_export"
      action.underscore
    when "Performs Export"
      action.titlecase
    else
      "🛑"
    end
  end
end
