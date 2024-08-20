class ChangeCoinsAttributes < ActiveRecord::Migration[7.0]
  def change
    remove_column :coins, :num_market_pairs
    remove_column :coins, :circulating_supply
    remove_column :coins, :total_supply
    remove_column :coins, :max_supply

    add_column :coins, :cmc_id, :integer
  end
end

