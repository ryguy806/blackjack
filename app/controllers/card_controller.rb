class CardController < ApplicationController
  def index
    @cards = Card.all.sample(52).sample(52)
  end
end
