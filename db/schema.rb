# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.1].define(version: 2025_10_29_133814) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string "namespace"
    t.text "body"
    t.string "resource_type"
    t.bigint "resource_id"
    t.string "author_type"
    t.bigint "author_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author"
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace"
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource"
  end

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "backup_settings", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.boolean "active"
    t.string "frequency"
    t.string "delivery_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_backup_settings_on_store_id"
  end

  create_table "contact_infos", force: :cascade do |t|
    t.string "contact_number"
    t.string "email"
    t.string "website_url"
    t.text "address"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "customer_dress_measurement_values", force: :cascade do |t|
    t.bigint "customer_dress_measurement_id", null: false
    t.bigint "dress_measurement_id", null: false
    t.decimal "value", precision: 5, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_dress_measurement_id"], name: "idx_on_customer_dress_measurement_id_64e52cbc3a"
    t.index ["dress_measurement_id"], name: "idx_on_dress_measurement_id_a068581263"
  end

  create_table "customer_dress_measurements", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "dress_id", null: false
    t.string "name", null: false
    t.integer "measurement_unit", default: 1
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_customer_dress_measurements_on_customer_id"
    t.index ["dress_id"], name: "index_customer_dress_measurements_on_dress_id"
  end

  create_table "customer_measurements", force: :cascade do |t|
    t.bigint "customer_id", null: false
    t.bigint "measurement_id", null: false
    t.decimal "value", precision: 5, scale: 2, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_customer_measurements_on_customer_id"
    t.index ["measurement_id"], name: "index_customer_measurements_on_measurement_id"
  end

  create_table "customers", force: :cascade do |t|
    t.string "name"
    t.string "contact_number"
    t.string "email"
    t.date "dob"
    t.integer "gender"
    t.text "address"
    t.integer "customer_reached_via"
    t.text "measurement_comment"
    t.bigint "store_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["store_id"], name: "index_customers_on_store_id"
  end

  create_table "dress_measurements", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "dress_id", null: false
    t.bigint "measurement_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dress_id"], name: "index_dress_measurements_on_dress_id"
    t.index ["measurement_id"], name: "index_dress_measurements_on_measurement_id"
  end

  create_table "dress_stitch_features", force: :cascade do |t|
    t.bigint "dress_id", null: false
    t.bigint "stitch_feature_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dress_id"], name: "index_dress_stitch_features_on_dress_id"
    t.index ["stitch_feature_id"], name: "index_dress_stitch_features_on_stitch_feature_id"
  end

  create_table "dresses", force: :cascade do |t|
    t.string "name", null: false
    t.integer "gender", null: false
    t.decimal "price"
    t.boolean "is_default", default: false, null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_dresses_on_user_id"
  end

  create_table "expertises", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "folders", force: :cascade do |t|
    t.string "name", null: false
    t.integer "gender", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "store_id"
    t.index ["store_id"], name: "index_folders_on_store_id"
    t.index ["user_id"], name: "index_folders_on_user_id"
  end

  create_table "gallery_categories", force: :cascade do |t|
    t.string "name"
    t.integer "category_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "garment_types", force: :cascade do |t|
    t.string "garment_name", null: false
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "job_roles", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_job_roles_on_user_id"
  end

  create_table "measurement_fields", force: :cascade do |t|
    t.string "label", null: false
    t.string "name"
    t.string "image_url"
    t.boolean "active", default: true, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "garment_type_id"
    t.index ["garment_type_id"], name: "index_measurement_fields_on_garment_type_id"
    t.index ["name"], name: "index_measurement_fields_on_name"
  end

  create_table "measurements", force: :cascade do |t|
    t.string "name", null: false
    t.integer "gender", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "media", force: :cascade do |t|
    t.boolean "favourite", default: false
    t.bigint "folder_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["folder_id"], name: "index_media_on_folder_id"
  end

  create_table "members", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_members_on_customer_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "title"
    t.string "body"
    t.boolean "read", default: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_notifications_on_user_id"
  end

  create_table "order_item_stitch_features", force: :cascade do |t|
    t.bigint "order_item_id", null: false
    t.bigint "stitch_feature_id", null: false
    t.integer "stitch_option_ids", default: [], array: true
    t.text "text_value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["order_item_id", "stitch_feature_id"], name: "index_order_item_stitch_features_on_order_item_and_feature", unique: true
    t.index ["order_item_id"], name: "index_order_item_stitch_features_on_order_item_id"
    t.index ["stitch_feature_id"], name: "index_order_item_stitch_features_on_stitch_feature_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.string "order_item_number", null: false
    t.integer "status", default: 0, null: false
    t.string "name"
    t.integer "work_type"
    t.text "special_instruction"
    t.string "video_link"
    t.boolean "measurement_dress_given", default: false
    t.integer "quantity", default: 1
    t.decimal "price"
    t.date "delivery_date"
    t.date "trial_date"
    t.date "function_date"
    t.date "completion_date"
    t.boolean "is_urgent", default: false
    t.bigint "order_id", null: false
    t.bigint "dress_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "customer_dress_measurement_id"
    t.bigint "member_id"
    t.bigint "garment_type_id"
    t.integer "stichfor"
    t.string "last_visited_screen"
    t.bigint "worker_id"
    t.index ["customer_dress_measurement_id"], name: "index_order_items_on_customer_dress_measurement_id"
    t.index ["dress_id"], name: "index_order_items_on_dress_id"
    t.index ["garment_type_id"], name: "index_order_items_on_garment_type_id"
    t.index ["member_id"], name: "index_order_items_on_member_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["worker_id"], name: "index_order_items_on_worker_id"
  end

  create_table "order_measurements", force: :cascade do |t|
    t.bigint "customer_id"
    t.bigint "member_id"
    t.bigint "order_item_id"
    t.bigint "order_id"
    t.bigint "measurement_field_id"
    t.decimal "value", precision: 8, scale: 2, null: false
    t.string "unit", default: "cm", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_order_measurements_on_customer_id"
    t.index ["measurement_field_id"], name: "index_order_measurements_on_measurement_field_id"
    t.index ["member_id"], name: "index_order_measurements_on_member_id"
    t.index ["order_id"], name: "index_order_measurements_on_order_id"
    t.index ["order_item_id"], name: "index_order_measurements_on_order_item_id"
  end

  create_table "orders", force: :cascade do |t|
    t.string "order_number", null: false
    t.date "order_date", null: false
    t.integer "status", default: 0, null: false
    t.decimal "total_bill_amount"
    t.decimal "payment_received"
    t.decimal "balance_due"
    t.decimal "discount"
    t.boolean "courier_to_customer", default: false
    t.bigint "store_id", null: false
    t.bigint "customer_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "worker_id"
    t.index ["customer_id"], name: "index_orders_on_customer_id"
    t.index ["store_id"], name: "index_orders_on_store_id"
    t.index ["worker_id"], name: "index_orders_on_worker_id"
  end

  create_table "services", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "settings", force: :cascade do |t|
    t.integer "measurement_unit", default: 1
    t.boolean "show_measurements_to_customer", default: false
    t.boolean "is_gst_enabled", default: false
    t.string "gst_number"
    t.decimal "gst_rate"
    t.boolean "include_gst_in_price", default: false
    t.integer "order_number_format", default: 0
    t.boolean "send_message_to_customer", default: false
    t.integer "order_statuses_for_message", default: [], array: true
    t.boolean "show_standard_dress_to_customer", default: false
    t.integer "default_order_list_days", default: 90
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "currency_type"
    t.index ["user_id"], name: "index_settings_on_user_id"
  end

  create_table "stitch_features", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "is_default", default: false, null: false
    t.integer "value_selection_type", null: false
    t.integer "gender", null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_stitch_features_on_user_id"
  end

  create_table "stitch_options", force: :cascade do |t|
    t.string "name", null: false
    t.bigint "stitch_feature_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["stitch_feature_id"], name: "index_stitch_options_on_stitch_feature_id"
  end

  create_table "store_bank_details", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.string "account_holder_name"
    t.string "bank_name"
    t.string "account_number"
    t.string "ifsc_code"
    t.string "upi_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "verified", default: false
    t.index ["store_id"], name: "index_store_bank_details_on_store_id"
  end

  create_table "store_galleries", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.integer "file_type", default: 0, null: false
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "gallery_category_id"
    t.index ["gallery_category_id"], name: "index_store_galleries_on_gallery_category_id"
    t.index ["store_id"], name: "index_store_galleries_on_store_id"
  end

  create_table "store_service_expertises", force: :cascade do |t|
    t.bigint "store_id", null: false
    t.bigint "service_id"
    t.bigint "expertise_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expertise_id"], name: "index_store_service_expertises_on_expertise_id"
    t.index ["service_id"], name: "index_store_service_expertises_on_service_id"
    t.index ["store_id"], name: "index_store_service_expertises_on_store_id"
  end

  create_table "stores", force: :cascade do |t|
    t.string "name", null: false
    t.string "code"
    t.integer "store_type", default: 0, null: false
    t.integer "stitches_for", default: 0, null: false
    t.boolean "is_main_store", default: false
    t.string "contact_number", null: false
    t.string "email"
    t.string "website_url"
    t.string "instagram_id"
    t.string "whatsapp_number"
    t.string "facebook_id"
    t.string "location_name"
    t.text "address"
    t.string "city"
    t.string "state"
    t.string "country"
    t.string "postal_code"
    t.string "map_location"
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "completed_steps", default: {}
    t.string "last_visited_screen"
    t.boolean "gst_included_on_bill", default: false
    t.string "gst_number"
    t.string "gst_name"
    t.decimal "gst_percentage"
    t.index ["user_id"], name: "index_stores_on_user_id"
  end

  create_table "subscription_packages", force: :cascade do |t|
    t.string "name", null: false
    t.decimal "price", precision: 10, scale: 2, default: "0.0"
    t.integer "store_limit"
    t.integer "duration_in_days"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "price_month"
    t.decimal "price_year"
    t.integer "duration_month"
    t.integer "duration_year"
  end

  create_table "tailor_subscriptions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "subscription_package_id", null: false
    t.date "start_date", null: false
    t.date "expiry_date"
    t.boolean "active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["subscription_package_id"], name: "index_tailor_subscriptions_on_subscription_package_id"
    t.index ["user_id"], name: "index_tailor_subscriptions_on_user_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.string "name", null: false
    t.integer "days", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_tasks_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "contact_number"
    t.string "jti", null: false
    t.integer "active_store_id"
    t.string "otp_code"
    t.datetime "otp_sent_at"
    t.datetime "otp_verified_at"
    t.string "email"
    t.string "mpin_digest"
    t.string "device_id"
    t.string "country_code"
    t.index ["contact_number"], name: "index_users_on_contact_number", unique: true
    t.index ["jti"], name: "index_users_on_jti", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "workers", force: :cascade do |t|
    t.string "name", null: false
    t.string "contact_number", null: false
    t.bigint "job_role_id", null: false
    t.bigint "store_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "mpin_digest"
    t.string "otp_code"
    t.string "jti"
    t.index ["job_role_id"], name: "index_workers_on_job_role_id"
    t.index ["store_id"], name: "index_workers_on_store_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "backup_settings", "stores"
  add_foreign_key "customer_dress_measurement_values", "customer_dress_measurements"
  add_foreign_key "customer_dress_measurement_values", "dress_measurements"
  add_foreign_key "customer_dress_measurements", "customers"
  add_foreign_key "customer_dress_measurements", "dresses"
  add_foreign_key "customer_measurements", "customers"
  add_foreign_key "customer_measurements", "measurements"
  add_foreign_key "customers", "stores"
  add_foreign_key "dress_measurements", "dresses"
  add_foreign_key "dress_measurements", "measurements"
  add_foreign_key "dress_stitch_features", "dresses"
  add_foreign_key "dress_stitch_features", "stitch_features"
  add_foreign_key "dresses", "users"
  add_foreign_key "folders", "stores"
  add_foreign_key "folders", "users"
  add_foreign_key "job_roles", "users"
  add_foreign_key "measurement_fields", "garment_types"
  add_foreign_key "media", "folders"
  add_foreign_key "members", "customers"
  add_foreign_key "notifications", "users"
  add_foreign_key "order_item_stitch_features", "order_items"
  add_foreign_key "order_item_stitch_features", "stitch_features"
  add_foreign_key "order_items", "customer_dress_measurements"
  add_foreign_key "order_items", "dresses"
  add_foreign_key "order_items", "garment_types"
  add_foreign_key "order_items", "members"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "workers"
  add_foreign_key "order_measurements", "customers"
  add_foreign_key "order_measurements", "measurement_fields"
  add_foreign_key "order_measurements", "members"
  add_foreign_key "order_measurements", "order_items"
  add_foreign_key "order_measurements", "orders"
  add_foreign_key "orders", "customers"
  add_foreign_key "orders", "stores"
  add_foreign_key "orders", "workers"
  add_foreign_key "settings", "users"
  add_foreign_key "stitch_features", "users"
  add_foreign_key "stitch_options", "stitch_features"
  add_foreign_key "store_bank_details", "stores"
  add_foreign_key "store_galleries", "gallery_categories"
  add_foreign_key "store_galleries", "stores"
  add_foreign_key "store_service_expertises", "expertises"
  add_foreign_key "store_service_expertises", "services"
  add_foreign_key "store_service_expertises", "stores"
  add_foreign_key "stores", "users"
  add_foreign_key "tailor_subscriptions", "subscription_packages"
  add_foreign_key "tailor_subscriptions", "users"
  add_foreign_key "tasks", "users"
  add_foreign_key "users", "stores", column: "active_store_id"
  add_foreign_key "workers", "job_roles"
  add_foreign_key "workers", "stores"
end
