class Deck
    #create the deck of cards and shuffle.
    def initialize
        @cards = Card::SUIT.flat_map do |suit|
            Card::RANK.map {|rank| Card.new(suit, rank)}
        end
        @cards.shuffle!
    end

end