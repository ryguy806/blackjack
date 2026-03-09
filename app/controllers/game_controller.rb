class GameController < ApplicationController

  def index
  end

  def new
  end

  def create
    balance = params[:balance].to_i
    balance = 1000 if balance < 100
    session[:game] = Game.new(balance).to_h
    redirect_to game_path
  end
  
  def show
  end
  
  def bet
    @game.bet(params[:wager])
    save_and_redirect
  end

  def hit
    @game.hit
    save_and_redirect
  end

  def stand
    @game.stand
    save_and_redirect
  end

end
