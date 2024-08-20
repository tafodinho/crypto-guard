class MarketDatum < ApplicationRecord
  belongs_to :coin, optional: true
end
