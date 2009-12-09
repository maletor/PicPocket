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

ActiveRecord::Schema.define(:version => 20091209042822) do

  create_table "ads", :force => true do |t|
    t.string   "sponsor"
    t.string   "product"
    t.string   "href"
    t.decimal  "video_length", :precision => 8, :scale => 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "adventures", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.integer  "owner"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "coupons", :force => true do |t|
    t.string   "sponsor_code"
    t.decimal  "amount",        :precision => 8, :scale => 2
    t.text     "description"
    t.string   "steganography"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "events", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.string   "category"
    t.datetime "start_time"
    t.datetime "finish_time"
    t.string   "address"
    t.text     "info"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "invitations", :force => true do |t|
    t.integer  "sender_id"
    t.string   "recipient_email"
    t.string   "token"
    t.datetime "sent_at"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "photo_timestamp"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "photo_file_name"
    t.string   "photo_content_type"
    t.integer  "photo_file_size"
    t.datetime "photo_updated_at"
    t.boolean  "flagged"
    t.integer  "flag_count",         :default => 0
    t.string   "status"
  end

  create_table "reports", :force => true do |t|
    t.integer  "user_id"
    t.integer  "photo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "username"
    t.string   "address"
    t.string   "phone"
    t.string   "encrypted_password",  :limit => 128
    t.string   "salt",                :limit => 128
    t.string   "confirmation_token",  :limit => 128
    t.string   "remember_token",      :limit => 128
    t.boolean  "email_confirmed",                    :default => false, :null => false
    t.boolean  "enhance",                            :default => true,  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "invitation_id"
    t.integer  "invitation_limit"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["id", "confirmation_token"], :name => "index_users_on_id_and_confirmation_token"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"

  create_table "videos", :force => true do |t|
    t.integer  "user_id"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "video_file_name"
    t.string   "video_content_type"
    t.integer  "video_file_size"
    t.datetime "video_updated_at"
  end

end
