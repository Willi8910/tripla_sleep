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

ActiveRecord::Schema[7.1].define(version: 2025_05_03_061251) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "btree_gist"
  enable_extension "pg_partman"
  enable_extension "plpgsql"

  create_table "following_users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.uuid "user_id", null: false
    t.uuid "following_user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["following_user_id"], name: "index_following_users_on_following_user_id"
    t.index ["user_id", "following_user_id"], name: "index_following_users_on_user_id_and_following_user_id", unique: true
    t.index ["user_id"], name: "index_following_users_on_user_id"
  end

  create_table "part_config", primary_key: "parent_table", id: :text, force: :cascade do |t|
    t.text "control", null: false
    t.text "time_encoder"
    t.text "time_decoder"
    t.text "partition_interval", null: false
    t.text "partition_type", null: false
    t.integer "premake", default: 4, null: false
    t.text "automatic_maintenance", default: "on", null: false
    t.text "template_table"
    t.text "retention"
    t.text "retention_schema"
    t.boolean "retention_keep_index", default: true, null: false
    t.boolean "retention_keep_table", default: true, null: false
    t.text "epoch", default: "none", null: false
    t.text "constraint_cols", array: true
    t.integer "optimize_constraint", default: 30, null: false
    t.boolean "infinite_time_partitions", default: false, null: false
    t.text "datetime_string"
    t.boolean "jobmon", default: true, null: false
    t.boolean "sub_partition_set_full", default: false, null: false
    t.boolean "undo_in_progress", default: false, null: false
    t.boolean "inherit_privileges", default: false
    t.boolean "constraint_valid", default: true, null: false
    t.boolean "ignore_default_data", default: true, null: false
    t.text "date_trunc_interval"
    t.integer "maintenance_order"
    t.boolean "retention_keep_publication", default: false, null: false
    t.timestamptz "maintenance_last_run"
    t.index ["partition_type"], name: "part_config_type_idx"
    t.check_constraint "(constraint_cols @> ARRAY[control]) <> true", name: "control_constraint_col_chk"
    t.check_constraint "check_automatic_maintenance_value(automatic_maintenance)", name: "part_config_automatic_maintenance_check"
    t.check_constraint "check_epoch_type(epoch)", name: "part_config_epoch_check"
    t.check_constraint "check_partition_type(partition_type)", name: "part_config_type_check"
    t.check_constraint "premake > 0", name: "positive_premake_check"
    t.check_constraint "retention_schema <> ''::text", name: "retention_schema_not_empty_chk"
  end

  create_table "part_config_sub", primary_key: "sub_parent", id: :text, force: :cascade do |t|
    t.text "sub_control", null: false
    t.text "sub_time_encoder"
    t.text "sub_time_decoder"
    t.text "sub_partition_interval", null: false
    t.text "sub_partition_type", null: false
    t.integer "sub_premake", default: 4, null: false
    t.text "sub_automatic_maintenance", default: "on", null: false
    t.text "sub_template_table"
    t.text "sub_retention"
    t.text "sub_retention_schema"
    t.boolean "sub_retention_keep_index", default: true, null: false
    t.boolean "sub_retention_keep_table", default: true, null: false
    t.text "sub_epoch", default: "none", null: false
    t.text "sub_constraint_cols", array: true
    t.integer "sub_optimize_constraint", default: 30, null: false
    t.boolean "sub_infinite_time_partitions", default: false, null: false
    t.boolean "sub_jobmon", default: true, null: false
    t.boolean "sub_inherit_privileges", default: false
    t.boolean "sub_constraint_valid", default: true, null: false
    t.boolean "sub_ignore_default_data", default: true, null: false
    t.boolean "sub_default_table", default: true
    t.text "sub_date_trunc_interval"
    t.integer "sub_maintenance_order"
    t.boolean "sub_retention_keep_publication", default: false, null: false
    t.boolean "sub_control_not_null", default: true
    t.check_constraint "(sub_constraint_cols @> ARRAY[sub_control]) <> true", name: "control_constraint_col_chk"
    t.check_constraint "check_automatic_maintenance_value(sub_automatic_maintenance)", name: "part_config_sub_automatic_maintenance_check"
    t.check_constraint "check_epoch_type(sub_epoch)", name: "part_config_sub_epoch_check"
    t.check_constraint "check_partition_type(sub_partition_type)", name: "part_config_sub_type_check"
    t.check_constraint "sub_premake > 0", name: "positive_premake_check"
    t.check_constraint "sub_retention_schema <> ''::text", name: "retention_schema_not_empty_chk"
  end

  create_table "sleep_records", id: false, force: :cascade do |t|
    t.uuid "id", default: -> { "gen_random_uuid()" }
    t.uuid "user_id", null: false
    t.timestamptz "clock_in", null: false
    t.interval "interval_duration"
    t.tstzrange "time_duration"
    t.date "date", null: false
    t.timestamptz "created_at", null: false
    t.timestamptz "updated_at", null: false
    t.index ["clock_in"], name: "index_sleep_records_on_clock_in"
    t.index ["interval_duration"], name: "index_sleep_records_on_interval_duration"
    t.index ["time_duration"], name: "index_sleep_records_on_time_duration", using: :gist
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "following_users", "users"
  add_foreign_key "following_users", "users", column: "following_user_id"
  add_foreign_key "part_config_sub", "part_config", column: "sub_parent", primary_key: "parent_table", name: "part_config_sub_sub_parent_fkey", on_update: :cascade, on_delete: :cascade, deferrable: :deferred
  add_foreign_key "sleep_records", "users", name: "sleep_records_user_id_fkey"
end
