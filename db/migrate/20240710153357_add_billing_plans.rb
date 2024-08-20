class AddBillingPlans < ActiveRecord::Migration[5.2]
  def change
    create_table :billing_plans do |t|
      t.belongs_to :billing_product, null: false              # The BillingProduct that the BillingPlan belongs to

      t.string :stripeid, null: false                         # To map to the Plan in Stripe
      t.string :stripe_plan_name                              # The name of the plan in Stripe
      t.decimal :amount, precision: 10, scale: 2, null: false # Price of the plan, in the corresponding currency's smallest unit (i.e., cents)

      t.timestamps
    end
  end
end