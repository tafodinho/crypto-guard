class Portfolio < ApplicationRecord
  belongs_to :user, optional: true
  has_many :portfolio_holdings,  dependent: :destroy
end
