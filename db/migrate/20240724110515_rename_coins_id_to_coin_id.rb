class RenameCoinsIdToCoinId < ActiveRecord::Migration[7.0]
  def change
    rename_column :portfolio_holdings, :coins_id, :coin_id
  end
end
