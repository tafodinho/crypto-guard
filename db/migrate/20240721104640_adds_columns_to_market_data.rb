class AddsColumnsToMarketData < ActiveRecord::Migration[7.0]
  def change
    add_column :market_data, :num_market_pairs, :integer
    add_column :market_data, :circulating_supply, :integer
    add_column :market_data, :total_supply, :integer
    add_column :market_data, :max_supply, :integer
  end
end
