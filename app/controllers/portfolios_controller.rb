class PortfoliosController < ApplicationController
  layout "dashboard"
  skip_before_action :verify_authenticity_token, only: [:generate, :delete_portfolio]
  # POST /portfolios/generate
  def index
    @portfolios = Portfolio.includes(portfolio_holdings: :coin).all.map do |portfolio|
      {
        id: portfolio.id,
        name: portfolio.name,
        description: portfolio.description,
        portfolio_holdings: portfolio.portfolio_holdings.map do |holding|
          {
            target_percentage: holding.target_percentage,
            coin_name: holding.coin.name,
            coin_symbol: holding.coin.symbol,
          }
        end
      }
    end
    puts @portfolios
  end

  def generate
    strategy = params[:strategy]&.to_sym || :simple_guard30

    # Create the service object
    service = Portfolio::PortfolioGenerationService.new(current_user, strategy: strategy)

    begin
      # Generate the portfolio
      portfolio = service.generate_portfolio
      render json: { message: "Portfolio generated successfully", portfolio: portfolio.to_json(include: :portfolio_holdings) }, status: :created
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def get_holdings
    portfolio_id = params[:portfolio_id]
    holdings = PortfolioHolding.where(portfolio_id: portfolio_id)
    begin
      render json: { message: "Potfolio holdings retrieved", holdings: holdings }, status: 200
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def update_user_portfolio
    portfolio_id = params["portfolio_id"]
    status = params["status"]
    
    begin
      userPortfolio = UserPortfolio.find_or_initialize_by(user: current_user, portfolio_id: portfolio_id)
        userPortfolio.update!(
          status: status,
        )
      render json: { message: "User potfolio updated", user_portfolio: userPortfolio }, status: 200
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end

  def delete_portfolio
    begin
      portfolio = Portfolio.find_by(id: params[:id])
      portfolio.destroy
      render json: { message: "Potfolio deleted", portfolio: portfolio }, status: 200
    rescue StandardError => e
      render json: { error: e.message }, status: :unprocessable_entity
    end
  end
  
end