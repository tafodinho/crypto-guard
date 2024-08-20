class StripeWebhooksController < ApplicationController
  skip_before_action :verify_authenticity_token
  def receive
    # Get the event payload and signature
    payload = request.body.read
    sig_header = request.headers["Stripe-Signature"]
    
    # Attempt to verify the signature. If successful, we'll handle the event
    begin
      event = Stripe::Webhook.construct_event(payload, sig_header, ENV["STRIPE_WEBHOOK_SIGNING_KEY"])
      ::Billing::HandleStripeEvent.new.call(event: event)
    # If we fail to verify the signature, then something was wrong with the request
    rescue JSON::ParserError, Stripe::SignatureVerificationError
      head 400
      return
    end

    # We've successfully processed the event without blowing up
    head 200
  end
end