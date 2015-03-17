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

ActiveRecord::Schema.define(:version => 20150317141348) do

  create_table "bank_translations", :force => true do |t|
    t.integer  "bank_id"
    t.string   "locale",     :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
    t.string   "image"
  end

  add_index "bank_translations", ["bank_id"], :name => "index_bank_translations_on_bank_id"
  add_index "bank_translations", ["locale"], :name => "index_bank_translations_on_locale"

  create_table "banks", :force => true do |t|
    t.string   "code"
    t.string   "buy_color"
    t.string   "sell_color"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "currencies", :force => true do |t|
    t.string   "code"
    t.integer  "ratio"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "currency_translations", :force => true do |t|
    t.integer  "currency_id"
    t.string   "locale",      :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "name"
  end

  add_index "currency_translations", ["currency_id"], :name => "index_currency_translations_on_currency_id"
  add_index "currency_translations", ["locale"], :name => "index_currency_translations_on_locale"

  create_table "page_translations", :force => true do |t|
    t.integer  "page_id"
    t.string   "locale",     :null => false
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "title"
    t.text     "content"
  end

  add_index "page_translations", ["locale"], :name => "index_page_translations_on_locale"
  add_index "page_translations", ["page_id"], :name => "index_page_translations_on_page_id"

  create_table "pages", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "pages", ["name"], :name => "index_pages_on_name"

  create_table "rates", :force => true do |t|
    t.date     "date"
    t.string   "currency"
    t.float    "rate"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.datetime "utc"
    t.integer  "bank_id"
    t.float    "buy_price"
    t.float    "sell_price"
  end

  add_index "rates", ["currency", "date"], :name => "index_rates_on_currency_and_date"
  add_index "rates", ["date", "currency"], :name => "index_rates_on_date_and_currency"
  add_index "rates", ["utc", "currency"], :name => "index_rates_on_utc_and_currency"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.integer  "role",                   :default => 0,  :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "provider"
    t.string   "uid"
    t.string   "nickname"
    t.string   "avatar"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["provider", "uid"], :name => "idx_users_provider"
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

end
