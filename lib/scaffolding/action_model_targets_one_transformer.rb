require "scaffolding/action_model_transformer"

class Scaffolding::ActionModelTargetsOneTransformer < Scaffolding::ActionModelTransformer
  def targets_n
    "targets_one"
  end

  def scaffold_action_model
    super

    # Add the action button to the target show partial.
    target_show_file = "./app/views/account/scaffolding/completely_concrete/tangible_things/show.html.erb"
    scaffold_add_line_to_file(
      target_show_file,
      "<%= render \"account/scaffolding/completely_concrete/tangible_things/targets_one_actions/new_button_one\", tangible_thing: @tangible_thing %>",
      RUBY_NEW_ACTION_MODEL_BUTTONS_PROCESSING_HOOK,
      prepend: true
    )

    # Add the action index partial to the target show view.
    scaffold_add_line_to_file(
      target_show_file,
      "<%= render 'account/scaffolding/completely_concrete/tangible_things/targets_one_actions/index', tangible_thing: @tangible_thing, targets_one_actions: @tangible_thing.targets_one_actions %>",
      RUBY_NEW_ACTION_MODEL_INDEX_VIEWS_PROCESSING_HOOK,
      prepend: true
    )

    # Add the has_many to the target model.
    scaffold_add_line_to_file(
      "./app/models/scaffolding/completely_concrete/tangible_thing.rb",
      "has_many :targets_one_actions, class_name: \"Scaffolding::CompletelyConcrete::TangibleThings::TargetsOneAction\", dependent: :destroy, foreign_key: :tangible_thing_id, enable_updates: true, inverse_of: :tangible_thing",
      HAS_MANY_HOOK,
      prepend: true
    )

    # Add the concern we have to add manually because otherwise it gets transformed.
    add_line_to_file(transform_string("app/models/scaffolding/completely_concrete/tangible_things/targets_one_action.rb"), "include Actions::TargetsOne", "include Actions::SupportsScheduling", prepend: true)

    # Restart the server to pick up the translation files
    restart_server

    # TODO This is a hack. Replace with Adam's real version of this upstream.
    lines = File.read("config/routes.rb").lines.map(&:chomp)

    lines.each_with_index do |line, index|
      if line.match?(transform_string("resources :targets_one_actions, except: collection_actions"))
        unless line.match? /do$/
          lines[index] = "#{line} do\nmember do\npost :approve\nend\nend\n"
        end
      end
    end

    File.write("config/routes.rb", lines.join("\n"))

    puts `standardrb --fix ./config/routes.rb #{transform_string("./app/models/scaffolding/completely_concrete/tangible_things/targets_one_action.rb")}`

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
      "Targets One to",
      "append an emoji to",
      "TargetsOne",
      "targets_one",
      "Targets One",
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
    when "Targets One to"
      # e.g. "Archive"
      # If someone wants language like "Targets One to", they have to add it manually or name their model that.
      action.titlecase
    when "append an emoji to"
      # e.g. "archive"
      # If someone wants language like "append an emoji to", they have to add it manually.
      action.humanize
    when "TargetsOne"
      action
    when "targets_one"
      action.underscore
    when "Targets One"
      action.titlecase
    else
      "🛑"
    end
  end
end
