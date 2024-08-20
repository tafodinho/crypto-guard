class CreateUserPortfolios < ActiveRecord::Migration[7.0]
  def change
    create_enum :types, ["private", "public",]
    create_table :portfolios do |t|
      t.references :user, null: false, foreign_key: true
      t.string :name
      t.enum :type, enum_type: "types"

      t.timestamps
    end
  end
end
