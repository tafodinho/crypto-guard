class BillingPortalController < ApplicationController
  def index
    customer =  ::Billing::CreateStripeBillingCustomer.new.call(user: current_user)

    session = Stripe::BillingPortal::Session.create(
      customer: customer.id,
    )
    redirect_to session.url, status: 303, allow_other_host: true
  end

  private 
  def back_to_root 
     redirect_to root_url
  end
end
