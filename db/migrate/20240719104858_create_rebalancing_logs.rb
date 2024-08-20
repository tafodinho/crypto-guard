class CreateRebalancingLogs < ActiveRecord::Migration[7.0]
  def change
    create_table :rebalancing_logs do |t|
      t.references :portfolio, null: false, foreign_key: true
      t.string :details

      t.timestamps
    end
  end
end
