class GameController < ApplicationController
  # responds_to :js

  def index
  end

  def show
    @cards = Card.all.sample(52)
  end

  def add_card
    respond_to do |format|
      format.js
    end
  end
end
