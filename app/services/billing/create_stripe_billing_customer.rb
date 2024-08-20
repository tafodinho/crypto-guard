class Billing::CreateStripeBillingCustomer
  def call(user:, stripe_token: nil)
    # First, we fetch all users with the same email
    existing_customers_with_email = Stripe::Customer.list({ email: user.email })["data"]

    # If we've found any matching customers for the user, grab it
    if existing_customers_with_email.size.positive?
      stripe_customer = existing_customers_with_email.first
    # Otherwise, let's create a new customer for the user
    else
      stripe_customer = Stripe::Customer.create({
        name: user.name,
        email: user.email,
        description: "Customer id: #{user.id}",
      })

      BillingCustomer.create!({
      user: user,
      stripeid: stripe_customer.id,
      default_source: stripe_customer.default_source,
    })
    end

    # Lastly, let's make sure we persist the customer on our end
   
    stripe_customer
  end
end