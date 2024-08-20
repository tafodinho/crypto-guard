class ChangeCustomAttributesDefaultOnUsers < ActiveRecord::Migration[7.0]
  def change
    change_column_default :users, :custom_attributes, {}
  end
end
