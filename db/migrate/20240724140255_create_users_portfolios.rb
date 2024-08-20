class CreateUsersPortfolios < ActiveRecord::Migration[7.0]
  def change
    create_enum :status_types, ["active", "inactive", ""]
    create_table :users_portfolios do |t|
      t.references :user, null: false, foreign_key: true
      t.references :portfolio, null: false, foreign_key: true
      t.enum :status, enum_type: "status_types"

      t.timestamps
    end
  end
end
