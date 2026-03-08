class Hand
    def initialize(bet = 0)
        @cards  = [] #Array for cards in hand
        @bet    = bet # Current bet
        @stood  = false # These are flags for game mechanics.
        @busted = false
        @done   = false
    end

    #add cards to the hand.
    def add(card)
        @cards << card #The << operator acts as an append method or concatination method.
    end

    #calculates the score of the current hand.
    def score
        total = cards.sum(:value)
        aces = card.count { |c| c.rank == 'A' }
        while total > 21 && aces > 0
            total -= 10
            aces -= 1
        end
        total
    end

    # predicate method, returns boolean, ends with ?
    def blackjack?
        cards.size == 2 && score == 21
    end
end