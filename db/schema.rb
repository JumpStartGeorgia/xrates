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

ActiveRecord::Schema.define(:version => 20150423122715) do

  create_table "api_method_translations", :force => true do |t|
    t.integer  "api_method_id"
    t.string   "locale",        :null => false
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "title"
    t.text     "content"
  end

  add_index "api_method_translations", ["api_method_id"], :name => "index_api_method_translations_on_api_method_id"
  add_index "api_method_translations", ["locale"], :name => "index_api_method_translations_on_locale"

  create_table "api_methods", :force => true do |t|
    t.integer  "api_version_id"
    t.string   "permalink"
    t.integer  "sort_order",     :default => 1
    t.boolean  "public",         :default => false
    t.date     "public_at"
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
  end

  add_index "api_methods", ["api_version_id", "permalink"], :name => "index_api_methods_on_api_version_id_and_permalink"
  add_index "api_methods", ["public"], :name => "index_api_methods_on_public"
  add_index "api_methods", ["public_at"], :name => "index_api_methods_on_public_at"
  add_index "api_methods", ["sort_order"], :name => "index_api_methods_on_sort_order"

  create_table "api_version_translations", :force => true do |t|
    t.integer  "api_version_id"
    t.string   "locale",         :null => false
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "title"
  end

  add_index "api_version_translations", ["api_version_id"], :name => "index_api_version_translations_on_api_version_id"
  add_index "api_version_translations", ["locale"], :name => "index_api_version_translations_on_locale"

  create_table "api_versions", :force => true do |t|
    t.string   "permalink"
    t.boolean  "public",     :default => false
    t.date     "public_at"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
  end

  add_index "api_versions", ["permalink"], :name => "index_api_versions_on_permalink"
  add_index "api_versions", ["public"], :name => "index_api_versions_on_public"
  add_index "api_versions", ["public_at"], :name => "index_api_versions_on_public_at"

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
  add_index "bank_translations", ["name"], :name => "index_bank_translations_on_name"

  create_table "banks", :force => true do |t|
    t.string   "code"
    t.string   "buy_color"
    t.string   "sell_color"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "order"
  end

  add_index "banks", ["code"], :name => "index_banks_on_code"
  add_index "banks", ["order"], :name => "index_banks_on_order"

  create_table "currencies", :force => true do |t|
    t.string   "code"
    t.integer  "ratio"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "currencies", ["code"], :name => "index_currencies_on_code"

  create_table "currency_translations", :force => true do |t|
    t.integer  "currency_id"
    t.string   "locale",      :null => false
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.string   "name"
  end

  add_index "currency_translations", ["currency_id"], :name => "index_currency_translations_on_currency_id"
  add_index "currency_translations", ["locale"], :name => "index_currency_translations_on_locale"
  add_index "currency_translations", ["name"], :name => "index_currency_translations_on_name"

  create_table "page_content_translations", :force => true do |t|
    t.integer  "page_content_id"
    t.string   "locale",          :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "title"
    t.text     "content"
  end

  add_index "page_content_translations", ["locale"], :name => "index_page_content_translations_on_locale"
  add_index "page_content_translations", ["page_content_id"], :name => "index_page_content_translations_on_page_content_id"

  create_table "page_contents", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "page_contents", ["name"], :name => "index_page_contents_on_name"

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

  add_index "rates", ["bank_id", "currency", "date"], :name => "index_rates_on_bank_id_and_currency_and_date"
  add_index "rates", ["bank_id", "currency", "utc"], :name => "index_rates_on_bank_id_and_currency_and_utc"
  add_index "rates", ["updated_at"], :name => "index_rates_on_updated_at"

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
