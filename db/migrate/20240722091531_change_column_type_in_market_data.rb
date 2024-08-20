class ChangeColumnTypeInMarketData < ActiveRecord::Migration[7.0]
  def change
    change_column :market_data, :circulating_supply, :decimal, :precision => 30, :scale => 0
    change_column :market_data, :total_supply, :decimal, :precision => 30, :scale => 0
    change_column :market_data, :max_supply, :decimal, :precision => 30, :scale => 0
    change_column :market_data, :volume_24h, :decimal, :precision => 30, :scale => 0
  end
end
