# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20190601012708) do

  create_table "admin_notes", :force => true do |t|
    t.string   "resource_id",     :null => false
    t.string   "resource_type",   :null => false
    t.integer  "admin_user_id"
    t.string   "admin_user_type"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "admin_notes", ["admin_user_type", "admin_user_id"], :name => "index_admin_notes_on_admin_user_type_and_admin_user_id"
  add_index "admin_notes", ["resource_type", "resource_id"], :name => "index_admin_notes_on_resource_type_and_resource_id"

  create_table "generic_fleets", :force => true do |t|
    t.integer  "squad_id"
    t.integer  "planet_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "generic_unit_id"
    t.boolean  "moving"
    t.integer  "destination_id"
    t.string   "type"
    t.integer  "balance"
    t.integer  "producing_unit_id"
    t.string   "fleet_name"
    t.boolean  "sabotaged"
    t.integer  "level"
    t.integer  "producing_unit2_id"
    t.integer  "carried_by_id"
    t.integer  "weapon1_id"
    t.integer  "weapon2_id"
    t.boolean  "leader"
    t.integer  "skill_id"
    t.integer  "round"
    t.boolean  "captured"
  end

  create_table "generic_units", :force => true do |t|
    t.string   "name"
    t.integer  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type"
    t.integer  "faction_mask"
    t.boolean  "hyperdrive"
    t.string   "description"
    t.integer  "subtype_id"
    t.integer  "heavy_loading_capacity"
    t.integer  "light_loading_capacity"
    t.string   "acronym"
  end

  create_table "generic_units_squads", :id => false, :force => true do |t|
    t.integer "generic_unit_id"
    t.integer "squad_id"
  end

  create_table "goals", :force => true do |t|
    t.text    "description"
    t.boolean "used"
  end

  create_table "messages", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "receiver_id"
    t.string   "title"
    t.text     "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "planets", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "squad_id"
    t.integer  "credits"
    t.integer  "ground_squad_id"
    t.boolean  "wormhole"
    t.boolean  "tradeport"
    t.integer  "last_player_id"
    t.string   "description"
    t.integer  "first_player_id"
    t.integer  "sector"
    t.boolean  "special"
    t.integer  "distance"
    t.integer  "x"
    t.integer  "y"
    t.integer  "balance"
    t.string   "domination"
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.string   "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_histories_on_item_and_table_and_month_and_year"

  create_table "results", :force => true do |t|
    t.integer  "generic_unit_id"
    t.integer  "quantity"
    t.integer  "planet_id"
    t.integer  "generic_fleet_id"
    t.integer  "blasted"
    t.integer  "captured"
    t.integer  "fled"
    t.integer  "squad_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "round_id"
    t.integer  "captor_id"
    t.boolean  "sabotaged"
    t.integer  "final_quantity"
    t.integer  "producing_unit_id"
    t.integer  "producing_unit2_id"
    t.string   "fleet_name"
    t.integer  "weapon1_id"
    t.integer  "weapon2_id"
    t.boolean  "leader"
    t.boolean  "automatic"
    t.integer  "skill_id"
    t.string   "description"
    t.integer  "not_landed"
    t.boolean  "moving"
  end

  create_table "rounds", :force => true do |t|
    t.integer  "number"
    t.boolean  "move"
    t.boolean  "attack"
    t.boolean  "done"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "routes", :force => true do |t|
    t.integer  "vector_a"
    t.integer  "vector_b"
    t.integer  "distance"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "settings", :force => true do |t|
    t.integer "net_planet_income"
    t.integer "bonus_planet_income"
    t.integer "facility_divisor_rate"
    t.integer "facility_upgrade_cost"
    t.integer "capital_ship_upgrade_cost"
    t.integer "maximum_warrior_life"
    t.boolean "upgradable_capital_ships"
    t.boolean "editable_automatic_results"
    t.integer "ground_income_rate"
    t.integer "initial_factories"
    t.integer "maximum_fleet_size"
    t.integer "initial_planets"
    t.integer "initial_fighters"
    t.integer "initial_capital_ships"
    t.integer "initial_transports"
    t.integer "initial_troopers"
    t.integer "initial_credits"
    t.boolean "tradeports"
    t.integer "maximum_facilities"
    t.integer "facility_primary_production_rate"
    t.integer "facility_secondary_production_rate"
    t.integer "facility_upgrade_rate"
    t.string  "air_domination_unit"
    t.string  "ground_domination_unit"
    t.string  "builder_unit"
    t.integer "minimum_quantity"
    t.integer "presence_to_influence"
    t.integer "rounds_to_dominate"
    t.integer "minimum_presence_to_construct"
  end

  create_table "squads", :force => true do |t|
    t.string   "name"
    t.integer  "credits"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "user_id"
    t.boolean  "ready"
    t.string   "color"
    t.integer  "faction"
    t.integer  "goal_id"
    t.integer  "home_planet_id"
    t.string   "url"
    t.integer  "map_ratio"
    t.boolean  "map_background"
    t.boolean  "ai"
  end

  create_table "subtypes", :force => true do |t|
    t.string "name"
    t.string "description"
  end

  create_table "tradeports", :force => true do |t|
    t.integer  "generic_unit_id"
    t.integer  "quantity"
    t.integer  "negotiation_rate"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "squad_id"
    t.integer  "planet_id"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                               :default => "", :null => false
    t.string   "encrypted_password",   :limit => 128, :default => "", :null => false
    t.string   "reset_password_token"
    t.string   "remember_token"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
