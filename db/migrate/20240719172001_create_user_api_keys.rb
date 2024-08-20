class CreateUserApiKeys < ActiveRecord::Migration[7.0]
  def change
    create_table :user_api_keys do |t|
      t.references :user, null: false, foreign_key: true
      t.string :exchange_name
      t.string :api_key
      t.string :api_secret

      t.timestamps
    end
  end
end
