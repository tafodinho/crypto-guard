class AddBillingEntities < ActiveRecord::Migration[7.0]
  def change
    create_table :billing_products do |t|
      t.string :stripeid, null: false            # To map to the Product in Stripe
      t.string :stripe_product_name, null: false # The name of the product in Stripe

      t.timestamps
    end

    create_table :billing_customers do |t|
      t.references :user

      t.string :stripeid, null: false # To map to the Customer in Stripe
      t.string :default_source        # Stripe identifier for the user's default payment source (initially null)

      t.timestamps
    end
  end
end