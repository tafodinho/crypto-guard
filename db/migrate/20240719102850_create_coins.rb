class CreateCoins < ActiveRecord::Migration[7.0]
  def change
    create_table :coins do |t|
      t.string :symbol
      t.string :name

      t.timestamps
    end
  end
end
