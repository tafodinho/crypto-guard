class BillingCustomer < ApplicationRecord
  belongs_to :user
  has_many :billing_subscriptions # Ignore this for now, we'll be adding this later
end