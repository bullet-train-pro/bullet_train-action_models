require "scaffolding/action_model_transformer"

class Scaffolding::ActionModelPerformsImportTransformer < Scaffolding::ActionModelTransformer
  def targets_n
    "performs_import"
  end

  def has_one_through
    "absolutely_abstract_creative_concept"
  end

  # Duplicated from `Scaffolding::ActionModelTargetsOneParentTransformer`.
  def add_button_to_index_rows
  end

  # Duplicated from `Scaffolding::ActionModelTargetsOneParentTransformer`.
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

    # Add the concern we have to add manually because otherwise it gets transformed.
    add_line_to_file(transform_string("app/models/scaffolding/completely_concrete/tangible_things/#{targets_n}_action.rb"), "include Actions::PerformsImport", "include Actions::ProcessesAsync", prepend: true)

    # Add current attributes of the target model to the import options.
    presentable_attributes.each do |attribute|
      add_line_to_file(transform_string("app/models/scaffolding/completely_concrete/tangible_things/#{targets_n}_action.rb"), ":#{attribute},", RUBY_NEW_FIELDS_HOOK, prepend: true)
    end

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
      "Performs Import to",
      "append an emoji to",
      "PerformsImport",
      "performs_import",
      "Performs Import",
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
    when "Performs Import to"
      # e.g. "Archive"
      # If someone wants language like "Targets Many to", they have to add it manually or name their model that.
      action.titlecase
    when "append an emoji to"
      # e.g. "archive"
      # If someone wants language like "append an emoji to", they have to add it manually.
      action.humanize
    when "PerformsImport"
      action
    when "performs_import"
      action.underscore
    when "Performs Import"
      action.titlecase
    else
      "🛑"
    end
  end
end
