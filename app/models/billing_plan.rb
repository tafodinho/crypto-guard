class BillingPlan < ApplicationRecord
  belongs_to :billing_product
  has_many :billing_subscriptions # Ignore this for now, we'll be adding this later
end