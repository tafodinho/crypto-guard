class AddBillingSubscriptions < ActiveRecord::Migration[5.2]
  def change
    create_table :billing_subscriptions do |t|
      t.belongs_to :billing_plan, null: false     # The BillingPlan that the BillingSubscription belongs to
      t.belongs_to :billing_customer, null: false # The BillingCustomer that the BillingSubscription belongs to

      t.string :stripeid, null: false             # To map to the Subscription in Stripe
      t.string :status, null: false               # The status of the Stripe subscription (trialing, active, etc.)

      t.datetime :current_period_end              # When the current subscription period will lapse
      t.datetime :cancel_at                       # If set to cancel, when the cancellation will occur

      t.timestamps
    end
  end
end