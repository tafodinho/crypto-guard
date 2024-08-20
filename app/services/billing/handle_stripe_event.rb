class Billing::HandleStripeEvent
  def call(event:)
    ensure_event_context(event)
    case @event.type
    # when "product.created", "product.updated", "product.deleted"
    #   SynchronizeBillingProducts.new.call
    # when "plan.created", "plan.updated", "plan.deleted"
    #   SynchronizeBillingPlans.new.call
    # when "customer.updated"
    #   process_subscription_updated()
    # when "customer.deleted"
    #   HandleStripeCustomerDeletedEvent.new.call({ event: event })
    when "customer.subscription.updated"
      # HandleStripeSubscriptionUpdatedEvent.new.call({ event: @event })
     process_subscription_updated
    when "customer.subscription.deleted"
      HandleStripeSubscriptionDeletedEvent.new.call({ event: event })
    # when "customer.subscription.created"
    #   process_subscription_updated
    else
      raise("Unexpected event from Stripe: #{event['type']}")
    end
  end

  private

  def process_subscription_updated
    puts "dog"
    return if account.blank?

    update_account_attributes(subscription)

  end

  def process_subscription_deleted
    # skipping self hosted plan events
    return if account.blank?

    Enterprise::Billing::CreateStripeCustomerService.new(account: account).perform
  end

  def update_account_attributes(subscription)
    # https://stripe.com/docs/api/subscriptions/object
    
   account.update(
      custom_attributes: {
        subscription_id: subscription['id'],
        stripe_customer_id: subscription.customer,
        stripe_price_id: subscription['plan']['id'],
        stripe_product_id: subscription['plan']['product'],
        plan_name: find_plan(subscription['plan']['product']),
        subscribed_quantity: subscription['quantity'],
        subscription_status: subscription['status'],
        subscription_ends_on: Time.zone.at(subscription['current_period_end'])
      }
    )
  end

  def ensure_event_context(event)
    @event = event
  end

  def subscription
    @subscription ||= @event.data.object
  end

  def account
    @account ||= User.where("custom_attributes->>'stripe_customer_id' = ?", subscription.customer).first
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