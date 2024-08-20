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

ActiveRecord::Schema[7.0].define(version: 2024_08_19_120905) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  # Custom types defined in this database.
  # Note that some types may not work with other database engines. Be careful if changing database.
  create_enum "mode_types", ["private", "public"]
  create_enum "status_types", ["active", "inactive"]
  create_enum "transactions_types", ["buy", "sell"]
  create_enum "types", ["private", "public"]

  create_table "billing_customers", force: :cascade do |t|
    t.bigint "user_id"
    t.string "stripeid", null: false
    t.string "default_source"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_billing_customers_on_user_id"
  end

  create_table "billing_plans", force: :cascade do |t|
    t.bigint "billing_product_id", null: false
    t.string "stripeid", null: false
    t.string "stripe_plan_name"
    t.decimal "amount", precision: 10, scale: 2, null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["billing_product_id"], name: "index_billing_plans_on_billing_product_id"
  end

  create_table "billing_products", force: :cascade do |t|
    t.string "stripeid", null: false
    t.string "stripe_product_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "billing_subscriptions", force: :cascade do |t|
    t.bigint "billing_plan_id", null: false
    t.bigint "billing_customer_id", null: false
    t.string "stripeid", null: false
    t.string "status", null: false
    t.datetime "current_period_end", precision: nil
    t.datetime "cancel_at", precision: nil
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["billing_customer_id"], name: "index_billing_subscriptions_on_billing_customer_id"
    t.index ["billing_plan_id"], name: "index_billing_subscriptions_on_billing_plan_id"
  end

  create_table "coins", force: :cascade do |t|
    t.string "symbol"
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "slug"
    t.bigint "cmc_rank"
    t.bigint "cmc_id"
  end

  create_table "market_data", force: :cascade do |t|
    t.bigint "coin_id", null: false
    t.decimal "price"
    t.decimal "market_cap"
    t.datetime "time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "num_market_pairs"
    t.decimal "circulating_supply", precision: 30
    t.decimal "total_supply", precision: 30
    t.decimal "max_supply", precision: 30
    t.datetime "last_updated"
    t.datetime "date_added"
    t.decimal "volume_24h", precision: 30
    t.decimal "percent_change_1h"
    t.decimal "percent_change_24h"
    t.decimal "percent_change_7d"
    t.index ["coin_id"], name: "index_market_data_on_coin_id"
  end

  create_table "portfolio_holdings", force: :cascade do |t|
    t.bigint "portfolio_id", null: false
    t.bigint "coin_id", null: false
    t.integer "quantity"
    t.decimal "target_percentage"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coin_id"], name: "index_portfolio_holdings_on_coin_id"
    t.index ["portfolio_id"], name: "index_portfolio_holdings_on_portfolio_id"
  end

  create_table "portfolios", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.enum "mode", enum_type: "mode_types"
    t.bigint "user_id"
    t.index ["user_id"], name: "index_portfolios_on_user_id"
  end

  create_table "rebalancing_logs", force: :cascade do |t|
    t.bigint "portfolio_id", null: false
    t.string "details"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["portfolio_id"], name: "index_rebalancing_logs_on_portfolio_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "coin_id", null: false
    t.enum "transaction_type", enum_type: "transactions_types"
    t.integer "quantity"
    t.decimal "price"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["coin_id"], name: "index_transactions_on_coin_id"
    t.index ["user_id"], name: "index_transactions_on_user_id"
  end

  create_table "user_api_keys", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "exchange_name"
    t.string "api_key"
    t.string "api_secret"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_api_keys_on_user_id"
  end

  create_table "user_preferences", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.integer "rebalance_frequency"
    t.string "notification_settings"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_preferences_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "provider"
    t.string "uid"
    t.string "name"
    t.json "custom_attributes", default: {}
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "users_portfolios", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "portfolio_id", null: false
    t.enum "status", enum_type: "status_types"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["portfolio_id"], name: "index_users_portfolios_on_portfolio_id"
    t.index ["user_id"], name: "index_users_portfolios_on_user_id"
  end

  add_foreign_key "market_data", "coins"
  add_foreign_key "portfolio_holdings", "coins"
  add_foreign_key "portfolio_holdings", "portfolios"
  add_foreign_key "portfolios", "users"
  add_foreign_key "rebalancing_logs", "portfolios"
  add_foreign_key "transactions", "coins"
  add_foreign_key "transactions", "users"
  add_foreign_key "user_api_keys", "users"
  add_foreign_key "user_preferences", "users"
  add_foreign_key "users_portfolios", "portfolios"
  add_foreign_key "users_portfolios", "users"
end
