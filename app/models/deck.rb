class Deck
    #create the deck of cards and shuffle.
    def initialize
        @cards = Card::SUITS.flat_map do |suit|
            Card::RANKS.map {|rank| Card.new(suit, rank)}
        end
        @cards.shuffle!
    end

    def deal
        @cards.pop
    end

    def to_a
        @cards.map(&:to_h)
    end

    def self.from_a(array)
        deck = allocate #using allocate instead of new so there is only ONE SINGLE instance of the deck.
        deck.instance_variable_set( :@cards, array.map {|h| Card.from_h(h)})
        deck
    end
end