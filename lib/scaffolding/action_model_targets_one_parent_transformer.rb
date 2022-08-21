require "scaffolding/action_model_transformer"

class Scaffolding::ActionModelTargetsOneParentTransformer < Scaffolding::ActionModelTransformer
  def targets_n
    "targets_one_parent"
  end

  # Disable this, we don't want it.
  def add_button_to_index_rows
  end

  def add_button_to_index
    {
      "./app/views/account/scaffolding/completely_concrete/tangible_things/index.html.erb" => "<%= render \"account/scaffolding/completely_concrete/tangible_things/#{targets_n}_actions/new_button_many\", absolutely_abstract_creative_concept: @absolutely_abstract_creative_concept %>",
      "./app/views/account/scaffolding/completely_concrete/tangible_things/_index.html.erb" => "<%= render \"account/scaffolding/completely_concrete/tangible_things/#{targets_n}_actions/new_button_many\", absolutely_abstract_creative_concept: absolutely_abstract_creative_concept %>",
    }.each do |file, code|
      scaffold_add_line_to_file(file, code, RUBY_NEW_TARGETS_ONE_PARENT_ACTION_MODEL_BUTTONS_HOOK, prepend: true)
    end
  end

  def scaffold_action_model
    super

    # Restart the server to pick up the translation files
    restart_server

    lines = File.read("config/routes.rb").lines.map(&:chomp)

    lines.each_with_index do |line, index|
      if line.include?(transform_string("resources :targets_one_parent_actions"))
        lines[index] = "#{line} do\nmember do\npost :approve\nend\nend\n"
        break
      end
    end

    File.write("config/routes.rb", lines.join("\n"))

    puts `standardrb --fix ./config/routes.rb #{transform_string("./app/models/scaffolding/completely_concrete/tangible_things/targets_one_parent_action.rb")}`

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
      "Targets One Parent to",
      "append an emoji to",
      "TargetsOneParent",
      "targets_one_parent",
      "Targets One Parent",
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
    when "Targets One Parent to"
      # e.g. "Archive"
      # If someone wants language like "Targets One Parent to", they have to add it manually or name their model that.
      action.titlecase
    when "append an emoji to"
      # e.g. "archive"
      # If someone wants language like "append an emoji to", they have to add it manually.
      action.humanize
    when "TargetsOneParent"
      action
    when "targets_one_parent"
      action.underscore
    when "Targets One Parent"
      action.titlecase
    else
      "🛑"
    end
  end
end
