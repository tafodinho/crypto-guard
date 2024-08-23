class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  has_many :portfolios
  
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :trackable, :omniauthable, 
         omniauth_providers: [:google_oauth2, :coinbase]

  # def self.from_google(u)
  #   create_with(uid: u[:uid], provider: 'google',
  #               password: Devise.friendly_token[0, 20]).find_or_create_by!(email: u[:email])
  # end

  def self.from_google(u)
    user = find_or_initialize_by(email: u[:email])
    user.assign_attributes(uid: u[:uid], name: u[:name], provider: 'google', password: Devise.friendly_token[0, 20])
    user.skip_confirmation!
    ::Billing::CreateStripeCustomerService.new(user).perform
    user.save!
    user
  end

  def self.from_coinbase(auth)
    user = find_or_initialize_by(email: auth.info.email)
    user.assign_attributes(
      uid: auth.uid,
      name: auth.info.name,
      provider: 'coinbase',
      token: auth.credentials.token,
      refresh_token: auth.credentials.refresh_token,
      expires_at: Time.at(auth.credentials.expires_at),
      password: Devise.friendly_token[0, 20]
    )
    # If you use Devise and have email confirmation enabled
    user.skip_confirmation! if user.respond_to?(:skip_confirmation!)

    # Add any additional actions such as creating a Stripe customer
    ::Billing::CreateStripeCustomerService.new(user).perform if defined?(::Billing::CreateStripeCustomerService)

    user.save!
    user
  end

  # def self.from_omniauth(access_token)
  #   data = access_token.info
  #   user = User.where(email: data['email']).first

  #   # Users are created if they don't exist
  #   unless user
  #     user = User.new(username: data['name'],
  #                     email: data['email'],
  #                     password: Devise.friendly_token[0, 20])
  #     user.skip_confirmation! # Add this line to skip confirmation
  #     user.save
  #   end
  #   user
  # end
end
