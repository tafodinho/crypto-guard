require 'net/http'
require 'json'

class UpdateCryptocurrencyMarketDataJob < ApplicationJob
  queue_as :default

  API_KEY = ENV["CMC_API_KEY"] || "32d5a78e-ca6f-4e98-8c44-2cc7a44315ca" # Make sure to replace with your actual API key
  BASE_URL = 'https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest'
  LIMIT = 100 # Number of coins per page

  def perform(*args)
    page = 1
    loop do
      response = fetch_data(page)
      Rails.logger.info("Response:  #{response}")
      break if response['data'].blank?

      process_data(response['data'])
      page += 1
    end
  end

  private

  def fetch_data(page)
    url = URI("#{BASE_URL}?start=#{(page - 1) * LIMIT + 1}&limit=#{LIMIT}")
    request = Net::HTTP::Get.new(url)
    request['X-CMC_PRO_API_KEY'] = API_KEY

    response = Net::HTTP.start(url.hostname, url.port, use_ssl: true) do |http|
      http.request(request)
    end

    JSON.parse(response.body)
  end

  def process_data(data)
    data.each do |coin_data|
      
      coin = Coin.find_by(:cmc_id => coin_data['id'])
      
      
      if coin.nil?
        # Log an error or handle the case where the coin is not found
        # Rails.logger.warn("Coin with cmc_id #{coin_data}")
        Rails.logger.warn("Coin with cmc_id #{coin_data['id']} not found.")
        next
      end
      market_datum = MarketDatum.find_or_initialize_by(:coins_id => coin.id)
      Rails.logger.info("Coin with cmc_id #{market_datum.coin.inspect} not found.")
      begin
        market_datum.update!(
          num_market_pairs: coin_data['num_market_pairs'],
          circulating_supply: coin_data['circulating_supply'],
          total_supply: coin_data['total_supply'],
          max_supply: coin_data['max_supply'],
          last_updated: coin_data['last_updated'],
          date_added: coin_data['date_added'],
          price: coin_data.dig('quote', 'USD', 'price'),
          volume_24h: coin_data.dig('quote', 'USD', 'volume_24h'),
          percent_change_1h: coin_data.dig('quote', 'USD', 'percent_change_1h'),
          percent_change_24h: coin_data.dig('quote', 'USD', 'percent_change_24h'),
          percent_change_7d: coin_data.dig('quote', 'USD', 'percent_change_7d'),
          market_cap: coin_data.dig('quote', 'USD', 'market_cap')
        )
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.error("Failed to update MarketDatum for coin_id #{coin.id}: #{e.message}")
      end
    end
  end

end
