class AddColumnsToMarketData < ActiveRecord::Migration[7.0]
  def change
    add_column :market_data, :last_updated, :datetime
    add_column :market_data, :date_added, :datetime
    add_column :market_data, :volume_24h, :integer
    add_column :market_data, :percent_change_1h, :decimal
    add_column :market_data, :percent_change_24h, :decimal
    add_column :market_data, :percent_change_7d, :decimal

    remove_column :market_data, :volume
  end
end
