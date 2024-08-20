class Portfolio::PortfolioGenerationService
  # Initialize with user and strategy parameters
  def initialize(user, strategy: :top_performers)
    @user = user
    @strategy = strategy
  end

  # Generate portfolio based on the chosen strategy
  def generate_portfolio
    portfolio = Portfolio.new(user: @user, mode: "public", name: "Portfolio Guard 30", description: "Collection of top 30 coins weighted by  thier market cap")
    if !portfolio.save
      raise "Portfolio could not be saved: #{portfolio.errors.full_messages.join(', ')}"
    end

    case @strategy
    when :top_performers
      allocate_top_performers(portfolio)
    when :balanced
      allocate_balanced(portfolio)
    when :simple_guard30
      allocate_simple_guard30(portfolio)
    else
      raise "Unknown strategy: #{@strategy}"
    end

    portfolio
  end

  private

  # Allocate coins based on top performers strategy
  def allocate_top_performers(portfolio)
    # Placeholder for top performers allocation logic
  end

  # Allocate coins based on balanced strategy
  def allocate_balanced(portfolio)
    # Placeholder for balanced allocation logic
  end

  # Allocate coins based on HODL 30 strategy
  def allocate_hodl30(portfolio)
    # Fetch the top 30 coins by current market cap
    top_30_coins = fetch_top_30_coins_by_market_cap

    # Calculate weights for the top 30 coins using EMA and square root market cap
    total_weight = 0.0
    coin_weights = top_30_coins.map do |coin|
      market_cap_history = coin.price_histories.order(fetched_at: :desc).pluck(:market_cap)
      ema_market_cap = calculate_ema(market_cap_history)
      sqrt_weight = Math.sqrt(ema_market_cap)
      total_weight += sqrt_weight
      [coin, sqrt_weight]
    end

    # Normalize and allocate percentages to the portfolio
    coin_weights.each do |coin, weight|
      percentage = (weight / total_weight) * 100.0
      portfolio.portfolio_coins.build(coin: coin, percentage: percentage)
    end
  end


   def allocate_simple_guard30(portfolio)
      top_30_coins = fetch_top_30_coins_by_market_cap
      total_cap = top_30_coins.sum(&:max_market_cap)
      puts portfolio.inspect
      top_30_coins.map do |coin|
        weight = (coin.max_market_cap / total_cap) * 100.0
        PortfolioHolding.find_or_create_by(coin: coin, portfolio: portfolio) do |holding|
          holding.target_percentage = weight
        end
      end
  end

  # Fetch the top 30 coins by current market cap
  def fetch_top_30_coins_by_market_cap
    stablecoin_symbols = ['USDT', 'USDC', 'DAI', 'BUSD', 'TUSD', 'PAX', 'USDe '] # Add more stablecoin symbols as needed

    Coin.joins(:market_data)
        .select('coins.*, MAX(market_data.market_cap) AS max_market_cap')
        .where.not(symbol: stablecoin_symbols) # Exclude stablecoins based on their symbols
        .group('coins.id')
        .order('max_market_cap DESC')
        .limit(30)
  end

  # Calculate the Exponential Moving Average for market cap
  def calculate_ema(market_cap_history, period: 2)
    k = 2 / period + 1
    ema = market_cap_history[0]
    market_cap_history.reverse_each do |market_cap|
      ema = (market_cap * k) + (ema * (1 - k))
    end
    ema
  end


end