module BulletTrain
  module ActionModels
    module Scaffolders
      class PrepareScaffolder < SuperScaffolding::Scaffolder
        def run
          unless argv.count >= 2
            puts ""
            puts "🚅  usage: bin/super-scaffold action-model:prepare <Model> <ParentModel>"
            puts ""
            puts "E.g. prepare to add action models to Membership on Team:"
            puts "  bin/super-scaffold action-model:prepare Membership Team"
            puts ""
            standard_protip
            puts ""
            exit
          end

          child = argv[0]
          parents = argv[1] ? argv[1].split(",") : []
          parents = parents.map(&:classify).uniq

          # get all the attributes.
          transformer = Scaffolding::Transformer.new(child, parents, @options)

          index_file = transformer.transform_string "./app/views/account/scaffolding/completely_concrete/tangible_things/_index.html.erb"
          index_file_content = File.read(index_file)
          block_manipulator = Scaffolding::BlockManipulator.new(index_file)

          unless index_file_content.include?("updates_for context, collection")
            puts "Adding `updates_for` block. (Increases indentation of the whole file.)".green
            block_manipulator.wrap_block(starting: "<%= render 'shared/box'", with: ["<%= updates_for context, collection do %>", "<% end %>"])
          end

          unless index_file_content.include?("action_model_select_controller")
            puts "Adding `action_model_select_controller` block. (Increases indentation of the whole file.)".green
            block_manipulator.wrap_block(starting: "<%= updates_for context, collection", with: ["<%= action_model_select_controller do %>", "<% end %>"])
          end

          unless index_file_content.include?("shared/tables/select_all")
            puts "Adding `select_all` to the <table>.".green
            block_manipulator.insert('  <%= render "shared/tables/select_all" %>', within: "<% p.content_for :table do %>", after: "<tr>")
          end

          unless index_file_content.include?("shared/tables/checkbox")
            puts "Adding per-row `checkbox` to the <table>.".green
            block_manipulator.insert(transformer.transform_string('  <%= render "shared/tables/checkbox", object: tangible_thing %>'), within: "<% p.content_for :table do %>", after: "<tr data-id")
          end

          target = transformer.transform_string("<% if context == absolutely_abstract_creative_concept %>")
          if index_file_content.include?(target)
            unless index_file_content.include?("super scaffolding will insert new bulk action model buttons above this line")
              puts "Adding Super Scaffolding hook for new bulk action buttons.".green
              block_manipulator.insert("<%# 🚅 super scaffolding will insert new bulk action model buttons above this line. %>", within: target, append: true)
            end

            unless index_file_content.include?("shared/bulk_action_select")
              puts "Adding bulk select button.".green
              block_manipulator.insert('<%= render "shared/bulk_action_select" %>', within: target, append: true)
              block_manipulator.insert("", within: target, after: "<%# 🚅 super scaffolding will insert new bulk action model buttons above this line. %>")
            end
          else
            target = "<% p.content_for :actions do %>"
            if index_file_content.include?(target)
              unless index_file_content.include?("super scaffolding will insert new bulk action model buttons above this line")
                puts "Adding Super Scaffolding hook for the bulk action buttons.".green
                block_manipulator.insert("<%# 🚅 super scaffolding will insert new bulk action model buttons above this line. %>", within: target, before: "global.buttons.back")
              end

              unless index_file_content.include?("shared/bulk_action_select")
                puts "Adding bulk select button.".green
                block_manipulator.insert('<%= render "shared/bulk_action_select" %>', within: target, before: "global.buttons.back")
              end
            end
          end

          unless index_file_content.include?("super scaffolding will insert new action model buttons above this line.")
            puts "Adding Super Scaffolding hook for new per-row action model buttons.".green
            block_manipulator.insert("<%# 🚅 super scaffolding will insert new action model buttons above this line. %>", within: "<% unless hide_actions %>", append: true)
          end

          unless index_file_content.include?("p.content_for :raw_footer")
            puts "Adding a raw footer to the box.".green
            block_manipulator.insert_block(["<% p.content_for :raw_footer do %>", "<% end %>"], after_block: "<% p.content_for :actions do")
            block_manipulator.insert("", after_block: "<% p.content_for :actions do")
          end

          unless index_file_content.include?("p.content_for :raw_footer")
            puts "Adding Super Scaffolding hook for new Action Model tables in the raw footer of the box.".green
            block_manipulator.insert("  <%# 🚅 super scaffolding will insert new action model index views above this line. %>", within: "<% p.content_for :raw_footer do", append: true)
          end

          block_manipulator.write

          show_file = transformer.transform_string "./app/views/account/scaffolding/completely_concrete/tangible_things/show.html.erb"
          show_file_content = File.read(show_file)
          block_manipulator = Scaffolding::BlockManipulator.new(show_file)

          unless show_file_content.include?(transformer.transform_string("updates_for @tangible_thing"))
            puts "Adding `updates_for` block. (Increases indentation of the whole file.)".green
            block_manipulator.wrap_block(starting: "<%= render 'shared/box'", with: [transformer.transform_string("<%= updates_for @tangible_thing do %>"), "<% end %>"])
          end

          target = "<% p.content_for :actions do %>"
          if show_file_content.include?(target)
            unless show_file_content.include?("super scaffolding will insert new action model buttons above this line")
              puts "Adding Super Scaffolding hook for the bulk action buttons.".green
              block_manipulator.insert("<%# 🚅 super scaffolding will insert new action model buttons above this line. %>", within: target, after: ".buttons.edit")
            end
          end

          unless show_file_content.include?("p.content_for :raw_footer")
            puts "Adding a raw footer to the box.".green
            block_manipulator.insert_block(["<% p.content_for :raw_footer do %>", "<% end %>"], after_block: "<% p.content_for :actions do")
            block_manipulator.insert("", after_block: "<% p.content_for :actions do")
          end

          unless show_file_content.include?("p.content_for :raw_footer")
            puts "Adding Super Scaffolding hook for new Action Model tables in the raw footer of the box.".green
            block_manipulator.insert("  <%# 🚅 super scaffolding will insert new action model index views above this line. %>", within: "<% p.content_for :raw_footer do", append: true)
          end

          block_manipulator.write
        end
      end
    end
  end
end
