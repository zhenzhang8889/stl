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

ActiveRecord::Schema.define(:version => 20130124144948) do

  create_table "authentications", :force => true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "token"
    t.string   "token_secret"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
    t.string   "image"
    t.string   "refresh_token"
    t.string   "token_expires_at"
  end

  add_index "authentications", ["user_id"], :name => "index_authentications_on_user_id"

  create_table "ckeditor_assets", :force => true do |t|
    t.string   "data_file_name",                  :null => false
    t.string   "data_content_type"
    t.integer  "data_file_size"
    t.integer  "assetable_id"
    t.string   "assetable_type",    :limit => 30
    t.string   "type",              :limit => 30
    t.integer  "width"
    t.integer  "height"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  add_index "ckeditor_assets", ["assetable_type", "assetable_id"], :name => "idx_ckeditor_assetable"
  add_index "ckeditor_assets", ["assetable_type", "type", "assetable_id"], :name => "idx_ckeditor_assetable_type"

  create_table "comments", :force => true do |t|
    t.text     "content"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
    t.integer  "commentable_id"
    t.string   "commentable_type"
    t.integer  "user_id"
    t.integer  "likes_count",      :default => 0, :null => false
  end

  add_index "comments", ["commentable_id"], :name => "index_comments_on_commentable_id"
  add_index "comments", ["user_id"], :name => "index_comments_on_user_id"

  create_table "compliments", :force => true do |t|
    t.integer  "user_id"
    t.integer  "motivator_id"
    t.string   "message"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  add_index "compliments", ["user_id"], :name => "index_compliments_on_user_id"

  create_table "conversations", :force => true do |t|
    t.string   "subject",    :default => ""
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "events", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "location"
    t.integer  "price"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "user_id"
  end

  create_table "exercises", :force => true do |t|
    t.string   "name"
    t.integer  "reps"
    t.float    "weight"
    t.string   "equipment"
    t.text     "description"
    t.string   "image_file_name"
    t.string   "image_content_type"
    t.integer  "image_file_size"
    t.datetime "image_updated_at"
    t.string   "video_file_name"
    t.string   "video_content_type"
    t.integer  "video_file_size"
    t.datetime "video_updated_at"
    t.integer  "workout_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  add_index "exercises", ["workout_id"], :name => "index_exercises_on_workout_id"

  create_table "feeds", :force => true do |t|
    t.integer  "user_id"
    t.integer  "feedable_id"
    t.string   "feedable_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "feeds", ["feedable_id"], :name => "index_feeds_on_feedable_id"
  add_index "feeds", ["user_id"], :name => "index_feeds_on_user_id"

  create_table "follows", :force => true do |t|
    t.integer  "followable_id",                      :null => false
    t.string   "followable_type",                    :null => false
    t.integer  "follower_id",                        :null => false
    t.string   "follower_type",                      :null => false
    t.boolean  "blocked",         :default => false, :null => false
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
  end

  add_index "follows", ["followable_id", "followable_type"], :name => "fk_followables"
  add_index "follows", ["follower_id", "follower_type"], :name => "fk_follows"

  create_table "goals", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.string   "name"
  end

  create_table "groups", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
    t.integer  "user_id"
  end

  create_table "images", :force => true do |t|
    t.string   "item_file_name"
    t.string   "item_content_type"
    t.integer  "item_file_size"
    t.datetime "item_updated_at"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  add_index "images", ["imageable_id"], :name => "index_images_on_imageable_id"

  create_table "likes", :force => true do |t|
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.integer  "likeable_id"
    t.string   "likeable_type"
    t.integer  "user_id"
  end

  add_index "likes", ["likeable_id"], :name => "index_likes_on_likeable_id"
  add_index "likes", ["user_id"], :name => "index_likes_on_user_id"

  create_table "messages", :force => true do |t|
    t.integer  "sender_id"
    t.integer  "recipient_id"
    t.boolean  "sender_deleted",    :default => false
    t.boolean  "recipient_deleted", :default => false
    t.string   "subject"
    t.text     "body"
    t.datetime "read_at"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  create_table "notifications", :force => true do |t|
    t.string   "email"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.integer  "user_id"
    t.string   "notify_method"
    t.boolean  "notified",        :default => false
    t.integer  "notifiable_id"
    t.string   "notifiable_type"
    t.boolean  "viewed"
    t.string   "behaviour"
    t.integer  "notifier_id"
    t.string   "attachment"
  end

  add_index "notifications", ["notifiable_id"], :name => "index_notifications_on_notifiable_id"
  add_index "notifications", ["notifiable_type"], :name => "index_notifications_on_notifiable_type"
  add_index "notifications", ["user_id"], :name => "index_notifications_on_user_id"
  add_index "notifications", ["viewed"], :name => "index_notifications_on_viewed"

  create_table "notifications1", :force => true do |t|
    t.string   "type"
    t.text     "body"
    t.string   "subject",              :default => ""
    t.integer  "sender_id"
    t.string   "sender_type"
    t.integer  "conversation_id"
    t.boolean  "draft",                :default => false
    t.datetime "updated_at",                              :null => false
    t.datetime "created_at",                              :null => false
    t.integer  "notified_object_id"
    t.string   "notified_object_type"
    t.string   "notification_code"
  end

  add_index "notifications1", ["conversation_id"], :name => "index_notifications1_on_conversation_id"

  create_table "posts", :force => true do |t|
    t.string   "name"
    t.string   "link"
    t.text     "body"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "user_id"
    t.integer  "comments_count", :default => 0, :null => false
    t.integer  "likes_count",    :default => 0, :null => false
    t.string   "shares"
  end

  create_table "receipts", :force => true do |t|
    t.integer  "receiver_id"
    t.string   "receiver_type"
    t.integer  "notification_id",                                  :null => false
    t.boolean  "read",                          :default => false
    t.boolean  "trashed",                       :default => false
    t.boolean  "deleted",                       :default => false
    t.string   "mailbox_type",    :limit => 25
    t.datetime "created_at",                                       :null => false
    t.datetime "updated_at",                                       :null => false
  end

  add_index "receipts", ["notification_id"], :name => "index_receipts_on_notification_id"

  create_table "relationships", :force => true do |t|
    t.integer  "follower_id"
    t.integer  "followed_id"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  add_index "relationships", ["followed_id"], :name => "index_relationships_on_followed_id"
  add_index "relationships", ["follower_id", "followed_id"], :name => "index_relationships_on_follower_id_and_followed_id", :unique => true
  add_index "relationships", ["follower_id"], :name => "index_relationships_on_follower_id"

  create_table "roles", :force => true do |t|
    t.string   "name"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  add_index "roles", ["name", "resource_type", "resource_id"], :name => "index_roles_on_name_and_resource_type_and_resource_id"
  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "services", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "location"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.integer  "likes_count",     :default => 0, :null => false
    t.integer  "comments_count",  :default => 0, :null => false
    t.integer  "user_id"
    t.string   "price"
    t.integer  "spots"
    t.date     "expiration_date"
    t.string   "shares"
  end

  create_table "specs", :force => true do |t|
    t.integer "user_id",                   :null => false
    t.string  "roles",     :default => ""
    t.string  "interests", :default => ""
    t.string  "goal",      :default => ""
    t.text    "bio",       :default => ""
  end

  create_table "stacked_items", :force => true do |t|
    t.integer  "stackable_id"
    t.string   "stackable_type"
    t.integer  "stack_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  create_table "stacks", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "likes_count"
    t.integer  "comments_count", :default => 0, :null => false
    t.string   "shares"
  end

  create_table "statuses", :force => true do |t|
    t.integer  "user_id"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
    t.text     "content"
    t.string   "attached_url_image"
    t.string   "attached_url"
    t.string   "attached_url_description"
    t.string   "attached_url_title"
    t.integer  "comments_count",           :default => 0, :null => false
    t.integer  "likes_count",              :default => 0, :null => false
    t.string   "shares"
  end

  add_index "statuses", ["user_id", "created_at"], :name => "index_microposts_on_user_id_and_created_at"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "thankings", :force => true do |t|
    t.integer  "user_id"
    t.integer  "thanker_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.string   "resource_class"
    t.integer  "resource_id"
  end

  add_index "thankings", ["thanker_id"], :name => "index_thankings_on_thanker_id"
  add_index "thankings", ["user_id"], :name => "index_thankings_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "username"
    t.integer  "gender"
    t.string   "interests"
    t.text     "bio"
    t.string   "goals"
    t.string   "name"
    t.integer  "compliments_count",      :default => 0,  :null => false
    t.integer  "thankings_count",        :default => 0,  :null => false
    t.integer  "feeds_count",            :default => 0,  :null => false
    t.string   "social_image"
    t.boolean  "auth_present"
    t.string   "location"
    t.string   "website"
    t.string   "tagline"
    t.string   "skills"
    t.integer  "followers_count",        :default => 0,  :null => false
    t.integer  "following_count",        :default => 0,  :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true

  create_table "users_roles", :id => false, :force => true do |t|
    t.integer "user_id"
    t.integer "role_id"
  end

  add_index "users_roles", ["user_id", "role_id"], :name => "index_users_roles_on_user_id_and_role_id"

  create_table "videos", :force => true do |t|
    t.string   "title"
    t.string   "panda_video_id"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
    t.integer  "videoable_id"
    t.string   "videoable_type"
    t.string   "youtube"
  end

  create_table "votes", :force => true do |t|
    t.integer  "post_id"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
    t.integer  "user_id"
  end

  create_table "workouts", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.integer  "user_id"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.integer  "comments_count", :default => 0, :null => false
    t.integer  "likes_count",    :default => 0, :null => false
    t.string   "shares"
  end

  add_index "workouts", ["user_id", "created_at"], :name => "index_workouts_on_user_id_and_created_at"

end
