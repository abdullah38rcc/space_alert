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
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150411145704) do

  create_table "bexrbs", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.string   "ra"
    t.string   "dec"
    t.string   "orbit_period"
    t.string   "maxi_flux_change_prob"
    t.string   "maxi_average_flux"
    t.string   "maxi_data"
    t.string   "maxi_url"
    t.string   "swift_flux_change_prob"
    t.string   "swift_average_flux"
    t.string   "swift_data"
    t.string   "swift_url"
    t.string   "fermi_flux_change_prob"
    t.string   "fermi_average_flux"
    t.string   "fermi_data"
    t.string   "fermi_url"
    t.string   "combined_plot"
    t.string   "plot_days"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "maxi_prob_color"
    t.string   "swift_prob_color"
    t.string   "fermi_prob_color"
  end

  create_table "feeds", force: true do |t|
    t.string   "url"
    t.string   "state"
    t.datetime "last_connected_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "parser_class"
    t.text     "post_data"
    t.string   "method"
  end

  create_table "news", force: true do |t|
    t.string   "title",      limit: 4000
    t.string   "desc",       limit: 4000
    t.string   "link",       limit: 4000
    t.datetime "pub_date"
    t.string   "image",      limit: 4000
    t.string   "code"
    t.string   "state"
    t.string   "category"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "source"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
