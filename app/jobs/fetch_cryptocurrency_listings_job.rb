require 'net/http'
require 'json'

class FetchCryptocurrencyListingsJob < ApplicationJob
  queue_as :default
  API_KEY = '32d5a78e-ca6f-4e98-8c44-2cc7a44315ca' # Make sure to replace with your actual API key
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
      puts coin_data['id']
      Coin.create_with(
        name: coin_data['name'],
        symbol: coin_data['symbol'],
        slug: coin_data['slug'],
        cmc_rank: coin_data['cmc_rank'],
        cmc_id: coin_data['id']
      ).find_or_create_by(cmc_id: coin_data['id'])
    end
  end
end