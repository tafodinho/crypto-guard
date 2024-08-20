class CreateWizardController < ApplicationController
  layout 'dashboard'
  def index
    @coins = [
      {
        coin: 'ETH',
        coin_icon: '🔷',
        market_cap: 195_320_840_000,
        '24h_change': -3.78,
      },
      {
        coin: 'BTC',
        coin_icon: '🪙',
        market_cap: 426_100_000_000,
        '24h_change': 1.56,
      },
      {
        coin: 'XLM',
        coin_icon: '⭐',
        market_cap: 8_675_000_000,
        '24h_change': -6.23,
      },
      {
        coin: 'ADA',
        coin_icon: '🌐',
        market_cap: 30_240_000_000,
        '24h_change': 4.12,
      },
      {
        coin: 'USDT',
        coin_icon: '💰',
        market_cap: 70_234_000_000,
        '24h_change': 0.12,
      },
      {
        coin: 'TRX',
        coin_icon: '🚀',
        market_cap: 5_037_000_000,
        '24h_change': -1.87,
      },
      {
        coin: 'XRP',
        coin_icon: '💠',
        market_cap: 19_123_000_000,
        '24h_change': 2.45,
      },
      {
        coin: 'LTC',
        coin_icon: '🌑',
        market_cap: 13_287_000_000,
        '24h_change': -0.99,
      },
      {
        coin: 'EOS',
        coin_icon: '🔗',
        market_cap: 3_452_000_000,
        '24h_change': 5.67,
      },
      {
        coin: 'BCH',
        coin_icon: '💵',
        market_cap: 10_452_000_000,
        '24h_change': -4.56,
      },
    ]
  end
end
