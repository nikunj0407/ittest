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

ActiveRecord::Schema.define(:version => 20131027170314) do

  create_table "chapters", :force => true do |t|
    t.string   "name"
    t.integer  "weightage"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "options", :force => true do |t|
    t.string   "key"
    t.integer  "val"
    t.integer  "question_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "questions", :force => true do |t|
    t.text     "cipher"
    t.string   "type"
    t.integer  "chapter_id"
    t.string   "img_file_name"
    t.string   "img_content_type"
    t.integer  "img_file_size"
    t.datetime "img_updated_at"
    t.integer  "weightage"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "test_details", :force => true do |t|
    t.integer  "test_result_id",                 :null => false
    t.integer  "question_id",                    :null => false
    t.text     "answer",         :default => "", :null => false
    t.integer  "score",          :default => 0,  :null => false
    t.integer  "user_id"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
  end

  create_table "test_results", :force => true do |t|
    t.integer  "user_id",                    :null => false
    t.integer  "obj_score",   :default => 0
    t.integer  "sub_score",   :default => 0
    t.integer  "total_score"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "",                          :null => false
    t.string   "encrypted_password",     :default => "",                          :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0,                           :null => false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name",                   :default => "",                          :null => false
    t.string   "institute_name",         :default => "TestIT Team"
    t.string   "institute_email",        :default => "testit.yuvabeat@gmail.com"
    t.boolean  "is_direct",              :default => true
    t.string   "mobile_no",              :default => ""
    t.integer  "max_tests",              :default => 10
    t.boolean  "is_admin",               :default => false
    t.boolean  "has_paid",               :default => false
    t.boolean  "is_guest",               :default => true
    t.datetime "created_at",                                                      :null => false
    t.datetime "updated_at",                                                      :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
