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

ActiveRecord::Schema[8.0].define(version: 2025_12_14_180625) do
  create_table "action_text_rich_texts", force: :cascade do |t|
    t.string "name", null: false
    t.text "body"
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["record_type", "record_id", "name"], name: "index_action_text_rich_texts_uniqueness", unique: true
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

  create_table "automations", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "trigger_type"
    t.string "action_type"
    t.boolean "active"
    t.string "schedule"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "campaigns", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "campaign_type"
    t.date "start_date"
    t.date "end_date"
    t.decimal "budget"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cart_items", force: :cascade do |t|
    t.integer "cart_id", null: false
    t.integer "product_id", null: false
    t.integer "quantity"
    t.string "size"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "variant_id"
    t.index ["cart_id"], name: "index_cart_items_on_cart_id"
    t.index ["product_id"], name: "index_cart_items_on_product_id"
    t.index ["variant_id"], name: "index_cart_items_on_variant_id"
  end

  create_table "carts", force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_carts_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.boolean "featured"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["featured"], name: "index_categories_on_featured"
  end

  create_table "collection_products", force: :cascade do |t|
    t.integer "collection_id", null: false
    t.integer "product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["collection_id"], name: "index_collection_products_on_collection_id"
    t.index ["product_id"], name: "index_collection_products_on_product_id"
  end

  create_table "collections", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "handle"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "contact_messages", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "subject"
    t.text "message"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "discount_usages", force: :cascade do |t|
    t.integer "discount_id", null: false
    t.integer "order_id", null: false
    t.integer "user_id", null: false
    t.decimal "order_amount"
    t.decimal "discount_amount"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["discount_id"], name: "index_discount_usages_on_discount_id"
    t.index ["order_id"], name: "index_discount_usages_on_order_id"
    t.index ["user_id"], name: "index_discount_usages_on_user_id"
  end

  create_table "discounts", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "discount_type"
    t.decimal "value"
    t.decimal "minimum_order_amount"
    t.integer "usage_limit"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "status", default: "active"
    t.text "description"
    t.index ["status"], name: "index_discounts_on_status"
  end

  create_table "option_types", force: :cascade do |t|
    t.string "name", null: false
    t.integer "position", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_option_types_on_name", unique: true
  end

  create_table "option_values", force: :cascade do |t|
    t.string "name"
    t.integer "option_type_id", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["option_type_id"], name: "index_option_values_on_option_type_id"
  end

  create_table "order_items", force: :cascade do |t|
    t.integer "order_id", null: false
    t.integer "product_id", null: false
    t.integer "quantity", default: 1, null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "size"
    t.string "color"
    t.integer "variant_id"
    t.index ["order_id"], name: "index_order_items_on_order_id"
    t.index ["product_id"], name: "index_order_items_on_product_id"
    t.index ["variant_id"], name: "index_order_items_on_variant_id"
  end

  create_table "orders", force: :cascade do |t|
    t.integer "user_id", null: false
    t.decimal "total_price"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "email"
    t.text "address"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.string "country"
    t.boolean "agree_to_terms"
    t.string "tracking_number"
    t.string "phone"
    t.string "stripe_session_id"
    t.string "stripe_payment_intent_id"
    t.string "payment_method", default: "stripe"
    t.string "payment_status", default: "pending"
    t.datetime "paid_at"
    t.string "checkout_session_id"
    t.string "stripe_customer_id"
    t.decimal "shipping_cost", precision: 10, scale: 2, default: "0.0"
    t.decimal "tax", precision: 10, scale: 2, default: "0.0"
    t.index ["checkout_session_id"], name: "index_orders_on_checkout_session_id"
    t.index ["stripe_session_id"], name: "index_orders_on_stripe_session_id", unique: true
    t.index ["user_id", "stripe_payment_intent_id"], name: "index_orders_on_user_id_and_stripe_payment_intent_id", unique: true
    t.index ["user_id"], name: "index_orders_on_user_id"
  end

  create_table "payment_methods", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "stripe_payment_method_id"
    t.string "brand"
    t.string "last4"
    t.integer "exp_month"
    t.integer "exp_year"
    t.boolean "is_default"
    t.string "fingerprint"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_payment_methods_on_user_id"
  end

  create_table "product_option_types", force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "option_type_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["option_type_id"], name: "index_product_option_types_on_option_type_id"
    t.index ["product_id", "option_type_id"], name: "index_product_option_types_on_product_id_and_option_type_id", unique: true
    t.index ["product_id"], name: "index_product_option_types_on_product_id"
  end

  create_table "product_recommendations", force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "recommended_product_id", null: false
    t.decimal "score", precision: 10, scale: 2, default: "0.0"
    t.decimal "support", precision: 10, scale: 6, default: "0.0"
    t.decimal "confidence", precision: 10, scale: 6, default: "0.0"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id", "recommended_product_id"], name: "idx_on_product_id_recommended_product_id_0b612b6746", unique: true
    t.index ["product_id"], name: "index_product_recommendations_on_product_id"
    t.index ["recommended_product_id"], name: "index_product_recommendations_on_recommended_product_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "stock"
    t.boolean "published"
    t.boolean "featured", default: false, null: false
    t.integer "category_id"
    t.integer "stock_quantity", default: 0, null: false
    t.text "option_types", default: "{}"
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["published"], name: "index_products_on_published"
  end

  create_table "recommendation_cache", force: :cascade do |t|
    t.integer "product_id", null: false
    t.integer "recommended_product_id", null: false
    t.float "similarity_score", null: false
    t.string "similarity_method", null: false
    t.integer "interaction_count", default: 0
    t.datetime "calculated_at"
    t.datetime "expires_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["expires_at"], name: "index_recommendation_cache_on_expires_at"
    t.index ["product_id", "similarity_method"], name: "index_recommendation_cache_on_product_id_and_similarity_method"
    t.index ["product_id"], name: "index_recommendation_cache_on_product_id"
    t.index ["recommended_product_id"], name: "index_recommendation_cache_on_recommended_product_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "key"
    t.string "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_interactions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "product_id", null: false
    t.string "interaction_type", null: false
    t.float "score", default: 1.0
    t.datetime "created_at"
    t.index ["product_id", "interaction_type"], name: "index_user_interactions_on_product_id_and_interaction_type"
    t.index ["product_id"], name: "index_user_interactions_on_product_id"
    t.index ["user_id", "product_id", "interaction_type"], name: "idx_on_user_id_product_id_interaction_type_20a725617c"
    t.index ["user_id"], name: "index_user_interactions_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0, null: false
    t.string "first_name"
    t.string "last_name"
    t.string "phone_number"
    t.date "date_of_birth"
    t.string "address_line1"
    t.string "address_line2"
    t.string "city"
    t.string "state"
    t.string "postal_code"
    t.string "country"
    t.datetime "current_sign_in_at"
    t.boolean "deleted", default: false, null: false
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "customer_group"
    t.string "stripe_customer_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "variant_option_values", force: :cascade do |t|
    t.integer "variant_id", null: false
    t.integer "option_value_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["option_value_id"], name: "index_variant_option_values_on_option_value_id"
    t.index ["variant_id", "option_value_id"], name: "index_variant_option_values_on_variant_id_and_option_value_id", unique: true
    t.index ["variant_id"], name: "index_variant_option_values_on_variant_id"
  end

  create_table "variants", force: :cascade do |t|
    t.integer "product_id", null: false
    t.string "sku"
    t.decimal "price"
    t.integer "stock", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "compare_at_price", precision: 10, scale: 2
    t.index ["product_id"], name: "index_variants_on_product_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "cart_items", "carts"
  add_foreign_key "cart_items", "products"
  add_foreign_key "carts", "users"
  add_foreign_key "collection_products", "collections"
  add_foreign_key "collection_products", "products"
  add_foreign_key "discount_usages", "discounts"
  add_foreign_key "discount_usages", "orders"
  add_foreign_key "discount_usages", "users"
  add_foreign_key "option_values", "option_types"
  add_foreign_key "order_items", "orders"
  add_foreign_key "order_items", "products"
  add_foreign_key "order_items", "variants"
  add_foreign_key "orders", "users"
  add_foreign_key "payment_methods", "users"
  add_foreign_key "product_option_types", "option_types"
  add_foreign_key "product_option_types", "products"
  add_foreign_key "product_recommendations", "products"
  add_foreign_key "product_recommendations", "products", column: "recommended_product_id"
  add_foreign_key "products", "categories"
  add_foreign_key "recommendation_cache", "products"
  add_foreign_key "recommendation_cache", "products", column: "recommended_product_id"
  add_foreign_key "user_interactions", "products"
  add_foreign_key "user_interactions", "users"
  add_foreign_key "variant_option_values", "option_values"
  add_foreign_key "variant_option_values", "variants"
  add_foreign_key "variants", "products"
end
