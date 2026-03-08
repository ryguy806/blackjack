class Game
    attr_accessor :deck, :player_hand, :dealer_hand, :step, :balance

    #start game by giving the player a starting balance.
    def def initialize(balance = 1000)
      @balance = balance
      @deck = Deck.new
      @step = :betting
      @player_hand = Hand.new
      @dealer_hand = Hand.new
    end

    # TODO Need to break game into steps
    # Steps
    # -Bet
    # -Deal
    # -Split
    # -Hit
    # -Stand
    # -Busted
    # -Done

    def bet(wager)
        @balance -= wager
    end

    def hit
        
    end

end