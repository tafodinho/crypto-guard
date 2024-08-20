class AddFieldsToCoins < ActiveRecord::Migration[7.0]
  def change
    add_column :coins, :slug, :string
    add_column :coins, :cmc_rank, :integer
    add_column :coins, :num_market_pairs, :integer
    add_column :coins, :circulating_supply, :integer
    add_column :coins, :total_supply, :integer
    add_column :coins, :max_supply, :integer
  end
end
