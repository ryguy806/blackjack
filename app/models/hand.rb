class Hand
    attr_accessor :cards, :bet, :stood, :busted, :done 

    def initialize(bet = 0)
        @cards = [] #Array for cards in hand
        @bet = bet # Current bet
        @stood = false # These are flags for game mechanics.
        @busted = false
        @done = false
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

    #checks to see if the user passed 21.
    def busted?
        score > 21
    end

    #checks to see if the game/turn has reached an end state.
    def active?
        !stood && !busted &&!done
    end

    def to_h
        {
            cards: cards.map(&:to_h), #maps cards using the Card.to_h mehtod.
            bet: bet,
            stood: stood,
            busted: busted,
            done: done
        }
    end

    def self.from_h(h)
        hand = new(h['bet'] || h[:bet] || 0)
        hand.cards = (h['cards'] || h[:cards] || []).map { |c| c = Card.from_h(c) } #Do this to remove possiblity of return nil
        hand.stood = h['stood'] || h[:stood] || false
        hand.busted = h['busted'] || h[:busted] || false
        hand.done = h['done'] || h[:done] || false
        hand
    end
end