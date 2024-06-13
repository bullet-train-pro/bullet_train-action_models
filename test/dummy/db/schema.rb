# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2022_07_21_223017) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "memberships", force: :cascade do |t|
    t.jsonb "role_ids"
    t.bigint "user_id", null: false
    t.bigint "team_id", null: false
    t.bigint "platform_agent_of_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_memberships_on_team_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

  create_table "oauth_access_tokens", force: :cascade do |t|
    t.bigint "resource_owner_id"
    t.bigint "application_id", null: false
    t.string "token", null: false
    t.string "refresh_token"
    t.integer "expires_in"
    t.datetime "revoked_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "last_used_at", precision: nil
    t.string "scopes"
    t.string "previous_refresh_token", default: "", null: false
    t.index ["application_id"], name: "index_oauth_access_tokens_on_application_id"
    t.index ["refresh_token"], name: "index_oauth_access_tokens_on_refresh_token", unique: true
    t.index ["resource_owner_id"], name: "index_oauth_access_tokens_on_resource_owner_id"
    t.index ["token"], name: "index_oauth_access_tokens_on_token", unique: true
  end

  create_table "oauth_applications", force: :cascade do |t|
    t.string "name", null: false
    t.string "uid", null: false
    t.string "secret", null: false
    t.bigint "team_id"
    t.text "redirect_uri"
    t.string "scopes", default: "", null: false
    t.boolean "confidential", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_oauth_applications_on_team_id"
    t.index ["uid"], name: "index_oauth_applications_on_uid", unique: true
  end

  create_table "sc_co_concrete_tangible_things_targets_one_parent_actions", force: :cascade do |t|
    t.bigint "absolutely_abstract_creative_concept_id", null: false
    t.datetime "started_at"
    t.datetime "completed_at"
    t.integer "target_count"
    t.integer "performed_count", default: 0
    t.datetime "scheduled_for"
    t.string "sidekiq_jid"
    t.bigint "created_by_id", null: false
    t.bigint "approved_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["absolutely_abstract_creative_concept_id"], name: "index_targets_one_parent_actions_on_creative_concept_id"
    t.index ["approved_by_id"], name: "index_targets_one_parents_on_approved_by_id"
    t.index ["created_by_id"], name: "index_targets_one_parents_on_created_by_id"
  end

  create_table "sc_completely_concrete_tangible_things_performs_export_actions", force: :cascade do |t|
    t.bigint "absolutely_abstract_creative_concept_id", null: false
    t.boolean "target_all", default: false
    t.jsonb "target_ids", default: []
    t.bigint "target_count"
    t.bigint "performed_count", default: 0
    t.bigint "created_by_id"
    t.bigint "approved_by_id"
    t.datetime "scheduled_for"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.string "sidekiq_jid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["absolutely_abstract_creative_concept_id"], name: "index_tangible_things_export_on_creative_concept_id"
    t.index ["approved_by_id"], name: "index_append_emoji_actions_on_approved_by_id"
    t.index ["created_by_id"], name: "index_append_emoji_actions_on_created_by_id"
  end

  create_table "sc_completely_concrete_tangible_things_targets_many_actions", force: :cascade do |t|
    t.bigint "absolutely_abstract_creative_concept_id", null: false
    t.boolean "target_all", default: false
    t.jsonb "target_ids", default: []
    t.string "emoji"
    t.bigint "target_count"
    t.bigint "performed_count", default: 0
    t.bigint "created_by_id"
    t.bigint "approved_by_id"
    t.datetime "scheduled_for"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.string "sidekiq_jid"
    t.integer "delay", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["absolutely_abstract_creative_concept_id"], name: "index_targets_many_actions_on_creative_concept_id"
    t.index ["approved_by_id"], name: "index_targets_many_actions_on_approved_by_id"
    t.index ["created_by_id"], name: "index_targets_many_actions_actions_on_created_by_id"
  end

  create_table "sc_completely_concrete_tangible_things_targets_one_actions", force: :cascade do |t|
    t.bigint "tangible_thing_id", null: false
    t.string "emoji"
    t.integer "target_count"
    t.integer "performed_count", default: 0
    t.bigint "created_by_id"
    t.bigint "approved_by_id"
    t.datetime "scheduled_for"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.string "sidekiq_jid"
    t.integer "delay", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["approved_by_id"], name: "index_targets_ones_on_approved_by_id"
    t.index ["created_by_id"], name: "index_targets_ones_on_created_by_id"
    t.index ["tangible_thing_id"], name: "index_tangible_things_targets_one_actions_on_tangible_thing_id"
  end

  create_table "scaffolding_absolutely_abstract_creative_concepts", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "team_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_scaffold_absolutely_abstract_creative_concept_on_team_id"
  end

  create_table "scaffolding_completely_concrete_tangible_things", force: :cascade do |t|
    t.bigint "absolutely_abstract_creative_concept_id", null: false
    t.string "text_field_value"
    t.string "button_value"
    t.string "cloudinary_image_value"
    t.date "date_field_value"
    t.string "email_field_value"
    t.string "password_field_value"
    t.string "phone_field_value"
    t.string "select_value"
    t.string "super_select_value"
    t.text "text_area_value"
    t.text "trix_editor_value"
    t.text "ckeditor_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["absolutely_abstract_creative_concept_id"], name: "index_tangible_things_on_creative_concept_id"
  end

  create_table "scaffolding_completely_concrete_tangible_things_performs_import", force: :cascade do |t|
    t.bigint "absolutely_abstract_creative_concept_id", null: false
    t.datetime "started_at"
    t.datetime "completed_at"
    t.integer "target_count"
    t.integer "performed_count", default: 0
    t.datetime "scheduled_for"
    t.string "sidekiq_jid"
    t.jsonb "mapping", default: []
    t.bigint "copy_mapping_from_id"
    t.integer "succeeded_count", default: 0
    t.integer "failed_count", default: 0
    t.bigint "created_by_id", null: false
    t.bigint "approved_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["absolutely_abstract_creative_concept_id"], name: "index_performs_import_actions_on_abstract_creative_concept_id"
    t.index ["approved_by_id"], name: "index_performs_imports_on_approved_by_id"
    t.index ["copy_mapping_from_id"], name: "index_performs_imports_on_copy_mapping_from_id"
    t.index ["created_by_id"], name: "index_performs_imports_on_created_by_id"
  end

  create_table "teams", force: :cascade do |t|
    t.string "name"
    t.string "slug"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "first_name"
    t.string "last_name"
    t.integer "current_team_id"
    t.jsonb "ability_cache"
    t.bigint "platform_agent_of_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "memberships", "teams"
  add_foreign_key "memberships", "users"
  add_foreign_key "oauth_access_tokens", "oauth_applications", column: "application_id"
  add_foreign_key "sc_co_concrete_tangible_things_targets_one_parent_actions", "memberships", column: "approved_by_id"
  add_foreign_key "sc_co_concrete_tangible_things_targets_one_parent_actions", "memberships", column: "created_by_id"
  add_foreign_key "sc_co_concrete_tangible_things_targets_one_parent_actions", "scaffolding_absolutely_abstract_creative_concepts", column: "absolutely_abstract_creative_concept_id"
  add_foreign_key "sc_completely_concrete_tangible_things_performs_export_actions", "memberships", column: "approved_by_id"
  add_foreign_key "sc_completely_concrete_tangible_things_performs_export_actions", "memberships", column: "created_by_id"
  add_foreign_key "sc_completely_concrete_tangible_things_performs_export_actions", "scaffolding_absolutely_abstract_creative_concepts", column: "absolutely_abstract_creative_concept_id"
  add_foreign_key "sc_completely_concrete_tangible_things_targets_many_actions", "memberships", column: "approved_by_id"
  add_foreign_key "sc_completely_concrete_tangible_things_targets_many_actions", "memberships", column: "created_by_id"
  add_foreign_key "sc_completely_concrete_tangible_things_targets_many_actions", "scaffolding_absolutely_abstract_creative_concepts", column: "absolutely_abstract_creative_concept_id"
  add_foreign_key "sc_completely_concrete_tangible_things_targets_one_actions", "memberships", column: "approved_by_id"
  add_foreign_key "sc_completely_concrete_tangible_things_targets_one_actions", "memberships", column: "created_by_id"
  add_foreign_key "sc_completely_concrete_tangible_things_targets_one_actions", "scaffolding_completely_concrete_tangible_things", column: "tangible_thing_id"
  add_foreign_key "scaffolding_absolutely_abstract_creative_concepts", "teams"
  add_foreign_key "scaffolding_completely_concrete_tangible_things", "scaffolding_absolutely_abstract_creative_concepts", column: "absolutely_abstract_creative_concept_id"
  add_foreign_key "scaffolding_completely_concrete_tangible_things_performs_import", "memberships", column: "approved_by_id"
  add_foreign_key "scaffolding_completely_concrete_tangible_things_performs_import", "memberships", column: "created_by_id"
  add_foreign_key "scaffolding_completely_concrete_tangible_things_performs_import", "scaffolding_absolutely_abstract_creative_concepts", column: "absolutely_abstract_creative_concept_id"
  add_foreign_key "scaffolding_completely_concrete_tangible_things_performs_import", "scaffolding_completely_concrete_tangible_things_performs_import", column: "copy_mapping_from_id"
end
