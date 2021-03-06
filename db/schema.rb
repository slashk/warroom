# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100329165322) do

  create_table "picks", :force => true do |t|
    t.integer  "player_id"
    t.integer  "user_id",     :null => false
    t.integer  "pick_number", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "picks", ["player_id"], :name => "index_picks_on_player_id"
  add_index "picks", ["user_id"], :name => "index_picks_on_user_id"

  create_table "players", :force => true do |t|
    t.integer  "yahoo_ref",    :default => 0
    t.string   "player"
    t.string   "team"
    t.string   "pos"
    t.string   "status"
    t.integer  "rank",         :default => 1300
    t.float    "IP"
    t.integer  "W"
    t.integer  "SV"
    t.integer  "K"
    t.float    "ERA"
    t.float    "WHIP"
    t.integer  "R"
    t.integer  "HR"
    t.integer  "RBI"
    t.integer  "SB"
    t.float    "AVG"
    t.integer  "orank"
    t.integer  "AB"
    t.integer  "prank"
    t.integer  "depth"
    t.string   "note"
    t.integer  "pW"
    t.integer  "pSV"
    t.integer  "pK"
    t.float    "pERA"
    t.float    "pWHIP"
    t.integer  "pR"
    t.integer  "pHR"
    t.integer  "pRBI"
    t.integer  "pSB"
    t.float    "pAVG"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "previousTeam"
    t.boolean  "unretainable", :default => false
  end

  add_index "players", ["orank"], :name => "index_players_on_orank"
  add_index "players", ["player"], :name => "index_players_on_player"
  add_index "players", ["pos"], :name => "index_players_on_pos"
  add_index "players", ["previousTeam"], :name => "index_players_on_previousTeam"
  add_index "players", ["rank"], :name => "index_players_on_rank"
  add_index "players", ["team"], :name => "index_players_on_team"
  add_index "players", ["yahoo_ref"], :name => "index_players_on_yahoo_ref"

  create_table "retainees", :force => true do |t|
    t.integer  "user_id"
    t.integer  "player_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "retainees", ["player_id"], :name => "index_retainees_on_player_id"
  add_index "retainees", ["user_id"], :name => "index_retainees_on_user_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "users", :force => true do |t|
    t.string   "login"
    t.string   "email"
    t.string   "crypted_password",          :limit => 40
    t.string   "salt",                      :limit => 40
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remember_token"
    t.datetime "remember_token_expires_at"
    t.integer  "team_id"
    t.string   "role"
    t.integer  "draft_order",                             :default => 1
    t.string   "team"
  end

  create_table "watchlists", :force => true do |t|
    t.integer  "player_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "watchlists", ["player_id"], :name => "index_watchlists_on_player_id"
  add_index "watchlists", ["user_id"], :name => "index_watchlists_on_user_id"

end
