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

ActiveRecord::Schema[7.0].define(version: 2023_04_14_212026) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "organisations", force: :cascade do |t|
    t.string "name", null: false
    t.string "hosted_domain", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pipelines", force: :cascade do |t|
    t.string "uuid", null: false
    t.string "api_key", null: false
    t.integer "base_size_id", null: false
    t.integer "boost_size_id", null: false
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "set_env", default: false, null: false
    t.bigint "organisation_id", null: false
    t.index ["organisation_id"], name: "index_pipelines_on_organisation_id"
  end

  create_table "review_apps", force: :cascade do |t|
    t.bigint "pipeline_id", null: false
    t.string "log_token", null: false
    t.string "app_id", null: false
    t.string "branch", null: false
    t.integer "pr_number"
    t.datetime "last_active_at", null: false
    t.integer "base_size_id", null: false
    t.integer "boost_size_id", null: false
    t.integer "current_size_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["app_id"], name: "index_review_apps_on_app_id", unique: true
    t.index ["log_token"], name: "index_review_apps_on_log_token", unique: true
    t.index ["pipeline_id"], name: "index_review_apps_on_pipeline_id"
  end

  create_table "users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "email", null: false
    t.string "encrypted_password", limit: 128, null: false
    t.string "confirmation_token", limit: 128
    t.string "remember_token", limit: 128, null: false
    t.boolean "admin", default: false, null: false
    t.bigint "organisation_id", null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email"
    t.index ["organisation_id"], name: "index_users_on_organisation_id"
    t.index ["remember_token"], name: "index_users_on_remember_token", unique: true
  end

  add_foreign_key "pipelines", "organisations"
  add_foreign_key "review_apps", "pipelines"
  add_foreign_key "users", "organisations"
end
