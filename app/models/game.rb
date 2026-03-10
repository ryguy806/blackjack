class Game
    attr_accessor :deck, :player_hand, :dealer_hand, :step, :balance, :message, :results

    def initialize(balance = 1000)
      @balance = balance
      @deck = Deck.new
      @step = :betting
      @player_hands = [] #Needs to be an array.
      @dealer_hand = Hand.new
      @active_hand = 0
      @message = "Place your bet!" # This message will change depending on the state and if there are errors.
      @results = "These are the results"
    end

    # TODO Need to break game into steps
    # Steps
    # -Bet
    # -Deal
    # Player turn
    # -Split (Needs to happen only on deal)
    # -Double_down
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
        hand = Hand.new(wager) #This is the initial deal.
        @player_hands = [hand] # Put hand into array
        deal_initial
        @step = :player_turn #Need to check balance to see if split possible.
        @message = change_message
    end

    def split
        return error('Not player turn') unless phase == :player_turn
        return error('Cannot split this hand') unless player_hands.first.splittable?
        return error('Insufficient balance') if balance < player_hands.first.bet

        @balance -= player_hands.first.bet
    end

    def hit # Need to be able to handle multiple hands, so do this per hand.
        return error("Please wait for your turn to hit.")  unless step == :player_turn
        player_hands.first.add(deck.deal)
        if player_hands.first.busted?
            player_hands.first.busted = true
            player_hands.first.done = true
            @message = "Bust! (#{player_hands.first.score})"
            @step = :dealer_turn
            dealer_turn
        else
            @message = "Hit - score: (#{player_hands.first.score})"
        end
    end

    def stand # Need to be able to handle multiple hands, so do this per hand.
        return error("Please wait for your turn to stand.") unless step == :player_turn
        player_hands.first.stood = true
        player_hands.first.done = true
        @message = "Stand! Your score = (#{player_hands.score})"
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
            player_hands: player_hands.first.to_h,
            dealer_hand: dealer_hand.to_h,
            step: step.to_s,
            balance: balance,
            message: message
        }
    end
    
    def self.from_h(h)
        game = allocate
        game.deck = Deck.from_a(h['deck'] || [])
        game.player_hands = Hand.from_h(h['player_hands'] || [])
        game.dealer_hand = Hand.from_h(h['dealer_hand'] || {})
        game.step = (h['step'] || 'betting').to_sym
        game.balance = h['balance'] || 1000
        game.message = h['message'] || ''
        game
    end
    
    private
        def deal_initial
            2.times { player_hands.first.add(deck.deal) }
            2.times { dealer_hand.add(deck.deal) }
        end

        def get_results #Find a way to loop through the hands to be able to handle multiple wins, losses, and pushes.
            @step = :game_over
            if player_hands.first.blackjack? && !dealer_hand.blackjack?
                @balance += (player_hands.first.bet * 2.5).to_i
                @message = "Blackjack! You win! Earned $#{(player_hands.bet * 1.5).to_i}!"
            elsif player_hands.first.busted?
                @message = "Bust! Try again."
            elsif dealer_hand.busted? || player_hands.first.score > dealer_hand.score
                @balance += player_hands.first.bet * 2
                @message = "You win! Earned $#{player_hands.bet}!"
            elsif player_hands.first.score == dealer_hand.score
                @balance += player_hands.first.bet
                @message = "Push. Money back."
            else
                @message = "Dealer wins. Lost $#{player_hands.bet}."
            end
        end

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