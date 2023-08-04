require "scaffolding/action_model_transformer"

class Scaffolding::ActionModelTargetsOneTransformer < Scaffolding::ActionModelTransformer
  def targets_n
    "targets_one"
  end

  def has_one_through
    "tangible_thing"
  end

  def add_button_to_index
  end

  def fix_parent_reference
    legacy_replace_in_file(migration_file_name, "t.references :tangible_thing, null: false, foreign_key: true", "t.references :tangible_thing, null: false, foreign_key: {to_table: \"scaffolding_completely_concrete_tangible_things\"}")
  end

  def add_has_many_to_parent_model
    # Add the has_many to the target model.
    scaffold_add_line_to_file(
      "./app/models/scaffolding/completely_concrete/tangible_thing.rb",
      "has_many :targets_one_actions, class_name: \"Scaffolding::CompletelyConcrete::TangibleThings::TargetsOneAction\", dependent: :destroy, foreign_key: :tangible_thing_id, enable_updates: true, inverse_of: :tangible_thing",
      HAS_MANY_HOOK,
      prepend: true
    )
  end

  def target_show_file
    @target_show_file ||= "./app/views/account/scaffolding/completely_concrete/tangible_things/show.html.erb"
  end

  def add_index_to_parent
    scaffold_add_line_to_file(
      target_show_file,
      "<%= render 'account/scaffolding/completely_concrete/tangible_things/targets_one_actions/index', tangible_thing: @tangible_thing, targets_one_actions: @tangible_thing.targets_one_actions %>",
      RUBY_NEW_ACTION_MODEL_INDEX_VIEWS_PROCESSING_HOOK,
      prepend: true
    )
  end

  def skip_parent_join
    false
  end

  def scaffold_action_model
    super

    # Add the action button to the target show partial.
    scaffold_add_line_to_file(
      target_show_file,
      "<%= render \"account/scaffolding/completely_concrete/tangible_things/targets_one_actions/new_button_one\", tangible_thing: @tangible_thing %>",
      RUBY_NEW_ACTION_MODEL_BUTTONS_PROCESSING_HOOK,
      prepend: true
    )

    # Add the concern we have to add manually because otherwise it gets transformed.
    add_line_to_file(transform_string("app/models/scaffolding/completely_concrete/tangible_things/targets_one_action.rb"), "include Actions::TargetsOne", "include Actions::ProcessesAsync", prepend: true)

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
