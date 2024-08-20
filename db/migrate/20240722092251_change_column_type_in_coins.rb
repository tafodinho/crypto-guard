class ChangeColumnTypeInCoins < ActiveRecord::Migration[7.0]
  def change
    change_column :coins, :cmc_rank, :bigint
    change_column :coins, :cmc_id, :bigint
  end
end
