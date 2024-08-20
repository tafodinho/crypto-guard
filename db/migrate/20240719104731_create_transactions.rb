class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_enum :transactions_types, ["buy", "sell"]
    create_table :transactions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :coin, null: false, foreign_key: true
      t.enum :transaction_type, enum_type: "transactions_types"
      t.integer :quantity
      t.decimal :price

      t.timestamps
    end
  end
end
