class Card
    SUITS  = %w[S H D C].freeze
    RANKS  = %w[2 3 4 5 6 7 8 9 10 J Q K A].freeze

    attr_reader :suit, :rank

    def initialize(suit, rank)
        @suit = suit
        @rank = rank
    end

    #define the initial value of the card based on the rank.
    def value
        if %w[J Q K].include?(rank)
            10
        elsif rank == 'A'
            11
        else
            rank.to_i
        end
    end

    #sending the cards to hand.
    def to_h
        { suit: suit, rank: rank }
    end

    def self.from_h(h)
        new(h['suit'] || h[:suit], h['rank'] || h[:rank])
    end
end
