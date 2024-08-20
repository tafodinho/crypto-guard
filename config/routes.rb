require 'sidekiq/web'
Rails.application.routes.draw do

    mount Sidekiq::Web => '/sidekiq'
    devise_for :users, controllers: {
         omniauth_callbacks: 'users/omniauth_callbacks'
    }
    post '/stripe/webhooks' => 'stripe_webhooks#receive'
    authenticate :user do 
      get '/dashboard' => 'dashboard#index'
      get '/portfolios' => 'portfolios#index'
      get '/create-wizard' => 'create_wizard#index'

      #payment endpoints
      get '/settings/integration'
      get '/settings/subscription'
      get '/settings/account'
      get '/settings/referal'

      # Payment endpoints
      post 'payments/create'
      get 'payments/success'
      get 'payments/cancel'

      # billing portal endpoints
      post '/billing-portal' => "billing_portal#index"

      
      root to: "dashboard#index"
    end

    resources :portfolios, only: [] do
      collection do
        post :generate
        get "holdings/:portfolio_id", to: "portfolios#get_holdings"
        delete ":id", to: "portfolios#delete_portfolio"
      end
    end
    # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

    # Defines the root path route ("/")
    # root "articles#index"
  end
