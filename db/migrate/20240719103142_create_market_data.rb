class CreateMarketData < ActiveRecord::Migration[7.0]
  def change
    create_table :market_data do |t|
      t.references :coin, null: false, foreign_key: true
      t.decimal :price
      t.integer :volume
      t.decimal :market_cap
      t.datetime :time

      t.timestamps
    end
  end
end
