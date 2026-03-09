class Game
    attr_accessor :deck, :player_hand, :dealer_hand, :step, :balance, :message

    def initialize(balance = 1000)
      @balance = balance
      @deck = Deck.new
      @step = :betting
      @player_hand = Hand.new
      @dealer_hand = Hand.new
      @message = "Place your bet!" # This message will change depending on the state and if there are errors.
    end

    # TODO Need to break game into steps
    # Steps
    # -Bet
    # -Deal
    # Player turn
    # -Split
    # -Hit
    # -Stand
    # -Busted
    # -Done
    # Dealer turn

    def place_bet(wager)
        return error('Not in betting phase') unless phase == :betting

        wager = wager.to_i
        return error('Invalid bet wager') if wager <= 0 || wager > balance

        @balance      -= wager
        hand           = Hand.new(wager)
        @player_hands  = [hand] 
        deal_initial
        @phase         = :player_turn
        @message       = resolve_opening_message
    end

    def hit    
    end

    def deal_initial
        player_hand.add(deck.deal)
        player_hand.add(deck.deal)
        dealer_hand.add(deck.deal)
        dealer_hand.add(deck.deal)
    end
    
    def to_h
        {
            deck: deck.to_a,
            player_hand: player_hand.to_h,
            dealer_hand: dealer_hand.to_h,
            step: step.to_s,
            balance: balance,
            message: message
        }
    end
    
    def self.from_h(h)
        game = allocate
        game.deck = Deck.from_a(h['deck'] || [])
        game.player_hand = Hand.from_h(h['player_hand'] || {})
        game.dealer_hand = Hand.from_h(h['dealer_hand'] || {})
        game.step = (h['step'] || 'betting').to_sym
        game.balance = h['balance'] || 1000
        game.message = h['message'] || ''
        game
    end
    
    private
        def error(message) #Needed a changeable error message that doesn't break stuff.
            @message = "Error: #{message}"
        end

        def change_message
            if player_hands.first.blackjack?
            'Blackjack!'
            else
            "Cards dealt. Score: #{player_hands.first.score}"
            end
        end
end