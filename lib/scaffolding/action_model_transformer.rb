class Scaffolding::ActionModelTransformer < Scaffolding::Transformer
  attr_accessor :action

  RUBY_NEW_ACTION_MODEL_BUTTONS_PROCESSING_HOOK = "<%# 🚅 super scaffolding will insert new action model buttons above this line. %>"
  RUBY_NEW_TARGETS_ONE_PARENT_ACTION_MODEL_BUTTONS_HOOK = "<%# 🚅 super scaffolding will insert new targets one parent action model buttons above this line. %>"
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

    Scaffolding::FileManipulator.add_line_to_yml_file(role_file, "#{action_model_class}: read", [:default, :models])
    Scaffolding::FileManipulator.add_line_to_yml_file(role_file, "#{action_model_class}: manage", [:admin, :models])
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

  def fix_parent_reference
    legacy_replace_in_file(migration_file_name, "t.references :absolutely_abstract_creative_concept, null: false, foreign_key: true", "t.references :absolutely_abstract_creative_concept, null: false, foreign_key: {to_table: \"scaffolding_absolutely_abstract_creative_concepts\"}")
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

  def migration_file_name
    @migration_file_name ||= `grep "create_table :#{transform_string("scaffolding_completely_concrete_tangible_things_#{targets_n}_actions")} do |t|" db/migrate/*`.split(":").first
  end

  def fix_created_by
    created_by_index_name = transform_string("index_scaffolding_completely_concrete_tangible_things_#{action.pluralize.underscore.downcase}_on_created_by_id")
    created_by_index_name = "index_#{action.pluralize.underscore.downcase}_on_created_by_id" if created_by_index_name.length > 63
    legacy_replace_in_file(migration_file_name, "t.references :created_by, null: false, foreign_key: true", created_by_reference(created_by_index_name) || "t.references :created_by, null: false, foreign_key: {to_table: \"memberships\"}, index: {name: \"#{created_by_index_name}\"}")
  end

  def fix_approved_by
    approved_by_index_name = transform_string("index_scaffolding_completely_concrete_tangible_things_#{action.pluralize.underscore.downcase}_on_approved_by_id")
    approved_by_index_name = "index_#{action.pluralize.underscore.downcase}_on_approved_by_id" if approved_by_index_name.length > 63
    legacy_replace_in_file(migration_file_name, "t.references :approved_by, null: false, foreign_key: true", approved_by_reference(approved_by_index_name) || "t.references :approved_by, null: true, foreign_key: {to_table: \"memberships\"}, index: {name: \"#{approved_by_index_name}\"}")
  end

  def fix_json_column_default(column, default = "[]")
    if Scaffolding.mysql?
      after_initialize = <<~RUBY
        after_initialize do
          self.#{column} ||= #{default}
        end
      RUBY

      scaffold_add_line_to_file("./app/models/scaffolding/completely_concrete/tangible_things/#{targets_n}_action.rb", after_initialize, CALLBACKS_HOOK, prepend: true)
    else
      legacy_replace_in_file(migration_file_name, "t.jsonb :#{column}", "t.jsonb :#{column}, default: #{default}")
    end
  end

  def fix_database_defaults
    legacy_replace_in_file(migration_file_name, "t.integer :performed_count", "t.integer :performed_count, default: 0")
    legacy_replace_in_file(migration_file_name, "t.integer :succeeded_count", "t.integer :succeeded_count, default: 0")
    legacy_replace_in_file(migration_file_name, "t.integer :failed_count", "t.integer :failed_count, default: 0")
    legacy_replace_in_file(migration_file_name, "t.boolean :target_all", "t.boolean :target_all, default: false")
  end

  def replace_has_one_team
    scaffold_replace_line_in_file(
      "./app/models/scaffolding/completely_concrete/tangible_things/#{targets_n}_action.rb",
      transform_string(has_one_team_replacement),
      transform_string("has_one :team, through: :absolutely_abstract_creative_concept")
    )
  end

  # This is a super hacky way to let the targets one transformer return false all the time.
  def skip_parent_join
    yield
  end

  def add_permit_joins_and_delegations
    sorted_permit_parents = (permit_parents && parents)
    joins, delegates = sorted_permit_parents.split(last_joinable_parent)
    joins << last_joinable_parent

    joins.each do |join|
      unless skip_parent_join { parent == join }
        scaffold_add_line_to_file(transform_string("app/models/scaffolding/completely_concrete/tangible_things/#{targets_n}_action.rb"), "has_one :#{join.underscore}, through: :tangible_thing", HAS_ONE_HOOK, prepend: true)
      end
    end

    delegates.each do |delegate|
      scaffold_add_line_to_file(transform_string("app/models/scaffolding/completely_concrete/tangible_things/#{targets_n}_action.rb"), "delegate :#{delegate.underscore}, to: :#{joins.last.underscore}", DELEGATIONS_HOOK, prepend: true)
    end
  end

  def presentable_attributes
    (child.constantize.new.attributes.keys - ["created_at", "updated_at"]).select do |attribute|
      I18n.t("#{child.underscore.pluralize}.fields.#{attribute}.heading", default: nil)
    end
  end

  # Here, we manually add the an action line (i.e. - `post 'approve'`) inside the new resources.
  # However, we should probably be passing this in as an option somewhere.
  def add_line_to_action_resource(content, routes_manipulator)
    [
      "resources",
      "namespace"
    ]. each do |block_type|
      # targets-one is the only action which generates a namespace,
      # so we skip this part for every other action.
      break if block_type == "namespace" && targets_n != "targets_one"

      # `options` is used frequently in the RoutesFileManipulator
      # and usually houses `:within` which designates a block's line number.
      options = {}

      parent_resource = transform_string("Scaffolding::CompletelyConcrete::TangibleThing").tableize
      options[:within] = Scaffolding::BlockManipulator.find_block_start(
        starting_from: "#{block_type} :#{parent_resource}",
        lines: routes_manipulator.lines
      )
      line_number = routes_manipulator.find_or_convert_resource_block(transform_string("#{targets_n}_actions"), **options)

      new_lines = Scaffolding::BlockManipulator.insert(
        content,
        lines: routes_manipulator.lines,
        within: routes_manipulator.lines[line_number]
      )
      routes_manipulator.lines = new_lines
    end
  end

  def scaffold_action_model
    fix_parent_reference
    fix_created_by
    fix_approved_by
    fix_database_defaults

    files = [
      "./app/models/scaffolding/completely_concrete/tangible_things/#{targets_n}_action.rb",
      "./app/controllers/account/scaffolding/completely_concrete/tangible_things/#{targets_n}_actions_controller.rb",
      "./app/controllers/api/v1/scaffolding/completely_concrete/tangible_things/#{targets_n}_actions_controller.rb",
      "./app/views/account/scaffolding/completely_concrete/tangible_things/#{targets_n}_actions",
      "./app/views/api/v1/scaffolding/completely_concrete/tangible_things/#{targets_n}_actions",
      "./test/models/scaffolding/completely_concrete/tangible_things/#{targets_n}_action_test.rb",
      "./test/factories/scaffolding/completely_concrete/tangible_things/#{targets_n}_actions.rb",
      "./test/controllers/api/v1/scaffolding/completely_concrete/tangible_things/#{targets_n}_actions_controller_test.rb",
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
    update_action_models_abstract_class(targets_n)
    add_permit_joins_and_delegations
    add_ability_line_to_roles_yml

    begin
      # Update the routes to add the namespace and action routes
      routing_details = [
        {
          file_name: "config/routes.rb",
          namespace: "account"
        },
        {
          file_name: "config/routes/api/v1.rb",
          namespace: "v1"
        }
      ]

      # TODO: Check if this covers all of the other action models properly.
      parent = targets_n == "targets_one" ?
        transform_string("Scaffolding::CompletelyConcrete::TangibleThing") : transform_string("Scaffolding::AbsolutelyAbstract::CreativeConcept")
      child = transform_string("Scaffolding::CompletelyConcrete::TangibleThings::#{targets_n.classify}Action")

      routing_details.each do |details|
        routes_manipulator = Scaffolding::RoutesFileManipulator.new(details[:file_name], child, parent)
        routes_manipulator.apply([details[:namespace]])
        add_line_to_action_resource("  post 'approve'", routes_manipulator)
        Scaffolding::FileManipulator.write(details[:file_name], routes_manipulator.lines)
      end
    rescue BulletTrain::SuperScaffolding::CannotFindParentResourceException => exception
      # TODO It would be great if we could automatically generate whatever the structure of the route needs to be and
      # tell them where to try and inject it. Obviously we can't calculate the line number, otherwise the robots would
      # have already inserted the routes, but at least we can try to do some of the complicated work for them.
      add_additional_step :red, "We were not able to generate the routes for your Action Model automatically because: \"#{exception.message}\" You'll need to add them manually, which admittedly can be complicated. See https://blog.bullettrain.co/nested-namespaced-rails-routing-examples/ for guidance. 🙇🏻‍♂️"
    end

    add_additional_step :yellow, "We've generated a new model and migration file for you, so make sure to run `rake db:migrate`."
  end
end
