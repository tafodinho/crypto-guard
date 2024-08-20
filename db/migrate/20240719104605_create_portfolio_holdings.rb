class CreatePortfolioHoldings < ActiveRecord::Migration[7.0]
  def change
    create_table :portfolio_holdings do |t|
      t.references :portfolio, null: false, foreign_key: true
      t.references :coin, null: false, foreign_key: true
      t.integer :quantity
      t.decimal :target_percentage

      t.timestamps
    end
  end
end
