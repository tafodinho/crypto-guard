class PaymentsController < ApplicationController
  def create
    #create stripe customer for payment, update if already created
    customer = CreateStripeBillingCustomer.new.call(user: current_user)
  
    session = Stripe::Checkout::Session.create( 
      customer: customer,
      payment_method_types: ['card'],
      line_items: [{
        price: 'price_1PbjjiILPAAla5fS1Op5sFCG', #price api id usually starts with price_ApIiD
        quantity: 1,
      }],
      mode: 'subscription',
      success_url:  payments_success_url,
      cancel_url: payments_cancel_url
     )
     redirect_to session.url, status: 303, allow_other_host: true
  end
  
  def success
    #handle successful payments
    redirect_to root_url, notice: "Purchase Successful"
  end
  
  def cancel
    #handle if the payment is cancelled
    redirect_to root_url, notice: "Purchase Unsuccessful"
  end


end
