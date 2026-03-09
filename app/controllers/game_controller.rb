class GameController < ApplicationController
  before_action :load_game, except: [:new, :create]

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
    @game.place_bet(params[:wager])
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

  def new_round
    new_game = Game.new(@game.balance)
    session[:game] = new_game.to_h
    redirect_to game_path
  end

  private
    
    def load_game
      if session[:game]
        @game = Game.from_h(session[:game])
      else
        redirect_to new_game_path
      end
    end
  
    def save_and_redirect
      session[:game] = @game.to_h
      redirect_to game_path
    end

end
