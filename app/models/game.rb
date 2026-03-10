class Game
    attr_accessor :deck, :player_hand, :dealer_hand, :step, :balance, :message, :results

    def initialize(balance = 1000)
      @balance = balance
      @deck = Deck.new
      @step = :betting
      @player_hand = Hand.new #Needs to be an array.
      @dealer_hand = Hand.new
      @message = "Place your bet!" # This message will change depending on the state and if there are errors.
      @results = "These are the results"  
    end

    # TODO Need to break game into steps
    # Steps
    # -Bet
    # -Deal
    # Player turn
    # -Split (Needs to happen only on deal)
    # -Hit
    # -Stand
    # -Busted
    # -Done
    # Dealer turn

    def place_bet(wager)
        return error('Not in betting phase') unless step == :betting

        wager = wager.to_i
        return error('Invalid bet wager') if wager <= 0 || wager > balance

        @balance -= wager
        hand = Hand.new(wager) #Need to do this per split hand.
        @player_hand = hand
        deal_initial
        @step = :player_turn #Need to check balance to see if split possible.
        @message = change_message
    end

    def split
    end

    def hit # Need to be able to handle multiple hands, so do this per hand.
        return error("Please wait for your turn to hit.")  unless step == :player_turn
        player_hand.add(deck.deal)
        if player_hand.busted?
            player_hand.busted = true
            player_hand.done = true
            @message = "Bust! (#{player_hand.score})"
            @step = :dealer_turn
            dealer_turn
        else
            @message = "Hit - score: (#{player_hand.score})"
        end
    end

    def stand # Need to be able to handle multiple hands, so do this per hand.
        return error("Please wait for your turn to stand.") unless step == :player_turn
        player_hand.stood = true
        player_hand.done = true
        @message = "Stand! Your score = (#{player_hand.score})"
        @step = :dealer_turn
        dealer_turn
    end

    def dealer_turn #Dealer able to split?
        return error("Not dealer turn") unless step == :dealer_turn

        while dealer_hand.score < 17
            dealer_hand.add(deck.deal)
        end

        @step = :game_over
        get_results
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
        def deal_initial
            2.times { player_hand.add(deck.deal) }
            2.times { dealer_hand.add(deck.deal) }
        end

        def get_results #Find a way to loop through the hands to be able to handle multiple wins, losses, and pushes.
            @step = :game_over
            if player_hand.blackjack? && !dealer_hand.blackjack?
                @balance += (player_hand.bet * 2.5).to_i
                @message = "Blackjack! You win! Earned $#{(player_hand.bet * 1.5).to_i}!"
            elsif player_hand.busted?
                @message = "Bust! Try again."
            elsif dealer_hand.busted? || player_hand.score > dealer_hand.score
                @balance += player_hand.bet * 2
                @message = "You win! Earned $#{player_hand.bet}!"
            elsif player_hand.score == dealer_hand.score
                @balance += player_hand.bet
                @message = "Push. Money back."
            else
                @message = "Dealer wins. Lost $#{player_hand.bet}."
            end
        end

        def error(message) #Needed a changeable error message that doesn't break stuff.
            @message = "Error: #{message}"
        end

        def change_message
            if player_hand.blackjack?
                'Blackjack!'
                else
                    "Cards dealt. Score: #{player_hand.score}"
            end
        end
end