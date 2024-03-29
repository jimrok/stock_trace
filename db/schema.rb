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

ActiveRecord::Schema.define(:version => 20131006153715) do

  create_table "stock_day_data", :force => true do |t|
    t.integer  "stock_code"
    t.integer  "data_time"
    t.float    "open"
    t.float    "close"
    t.float    "high"
    t.float    "low"
    t.integer  "volume"
    t.float    "adj_close"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "stock_day_data", ["data_time"], :name => "index_stock_day_data_on_data_time"

  create_table "stocks", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.string   "short_name"
    t.string   "market_code"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

end
