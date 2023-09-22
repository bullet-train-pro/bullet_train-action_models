require "scaffolding/action_model_transformer"

class Scaffolding::ActionModelTargetsManyTransformer < Scaffolding::ActionModelTransformer
  def targets_n
    "targets_many"
  end

  def has_one_through
    "absolutely_abstract_creative_concept"
  end

  def scaffold_action_model
    super

    # Add the concern we have to add manually because otherwise it gets transformed.
    add_line_to_file(transform_string("app/models/scaffolding/completely_concrete/tangible_things/#{targets_n}_action.rb"), "include Actions::TargetsMany", "include Actions::ProcessesAsync", prepend: true)

    # Restart the server to pick up the translation files
    restart_server

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
