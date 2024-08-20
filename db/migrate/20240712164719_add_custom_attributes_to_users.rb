class AddCustomAttributesToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :custom_attributes, :json
  end
end
