class Billing::CreateStripeCustomerService

  DEFAULT_QUANTITY = 2

  def initialize(account)
    @account = account
  end

  def perform
    customer_id = prepare_customer_id
    subscription_id = account.custom_attributes["subscription_id"]

    if subscription_id.blank?
      subscription = Stripe::Subscription.create(
        {
          customer: customer_id,
          items: [{ price: price_id, quantity: default_quantity }],
          trial_period_days: 7
        }
      )
      account.update!(
        custom_attributes: {
          subscription_id: subscription['id'],
          stripe_customer_id: customer_id,
          stripe_price_id: subscription['plan']['id'],
          stripe_product_id: subscription['plan']['product'],
          plan_name: find_plan(subscription['plan']['product']),
          subscribed_quantity: subscription['quantity'],
          subscription_status: subscription['status'],
          subscription_ends_on: Time.zone.at(subscription['current_period_end'])
        }
      )
    end
  end

  private

  def prepare_customer_id
    puts "fish", account.custom_attributes
    customer_id = account.custom_attributes['stripe_customer_id']
    if customer_id.blank?
      customer = Stripe::Customer.create({ name: account.name, email: billing_email })
      customer_id = customer.id
    end
    customer_id
  end

  def default_quantity
    DEFAULT_QUANTITY
  end

  def billing_email
    account.email
  end

  def account
    @account
  end

  def price_id
    "price_1Pb36kILPAAla5fSL8CTVTqk"
  end

  def find_plan(product_id)
    if product_id == "prod_QRx1QNuBrfRNt3"
      "premium"
    elsif product_id == "prod_QRx1cX4d90h6ud"
      "standard"
    elsif product_id == "prod_QRx0hgtD3ad3iU"
      "basic"
    else
      "null"
    end
  end
end

