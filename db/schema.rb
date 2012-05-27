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

ActiveRecord::Schema.define(:version => 20120526223513) do

  create_table "chapters", :force => true do |t|
    t.integer  "story_id"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",      :default => "Untitled"
  end

  create_table "element_relationships", :force => true do |t|
    t.float    "width",      :default => 0.0
    t.float    "height",     :default => 0.0
    t.float    "left",       :default => 0.0
    t.float    "top",        :default => 0.0
    t.integer  "pid"
    t.integer  "cid"
    t.integer  "sid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "zindex",     :default => 0
  end

  add_index "element_relationships", ["cid"], :name => "index_element_relationships_on_cid"
  add_index "element_relationships", ["pid", "cid"], :name => "index_element_relationships_on_pid_and_cid"
  add_index "element_relationships", ["pid"], :name => "index_element_relationships_on_pid"
  add_index "element_relationships", ["sid", "pid", "cid"], :name => "index_element_relationships_on_sid_and_pid_and_cid", :unique => true
  add_index "element_relationships", ["sid"], :name => "index_element_relationships_on_sid"

  create_table "elements", :force => true do |t|
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "metadata"
  end

  create_table "scene_data", :force => true do |t|
    t.integer  "scene_id"
    t.integer  "element_id"
    t.float    "width",      :default => 0.0
    t.float    "height",     :default => 0.0
    t.float    "left",       :default => 0.0
    t.float    "top",        :default => 0.0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "zindex",     :default => 0
  end

  add_index "scene_data", ["element_id"], :name => "index_scene_data_on_element_id"
  add_index "scene_data", ["scene_id", "element_id"], :name => "index_scene_data_on_scene_id_and_element_id", :unique => true
  add_index "scene_data", ["scene_id"], :name => "index_scene_data_on_scene_id"

  create_table "scenes", :force => true do |t|
    t.integer  "chapter_id"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "number"
  end

  create_table "stories", :force => true do |t|
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "title",      :default => "Untitled"
    t.string   "summary",    :default => "Unwritten"
  end

  create_table "users", :force => true do |t|
    t.string   "email",                                 :default => "",          :null => false
    t.string   "encrypted_password",     :limit => 128, :default => "",          :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                         :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "points",                                :default => 0
    t.string   "name",                                  :default => "anonymous"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
