class AddsModifyColumnOnPortfolio < ActiveRecord::Migration[7.0]
  def change
     create_enum :mode_types, ["private", "public"]
     add_column :portfolios, :mode, :enum, enum_type: "mode_types"
     #Ex:- add_column("admin_users", "username", :string, :limit =>25, :after => "email")
     remove_column :portfolios, :type
  end
end
