class ChangeUserIdInPortfolios < ActiveRecord::Migration[7.0]
  def change
    remove_column :portfolios, :users_id
    add_reference :portfolios, :user, foreign_key: true
    #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
  end
end
