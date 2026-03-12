class Game
    attr_accessor :deck, :player_hands, :dealer_hand, :step, :balance, :message, :results, :active_hand

    def initialize(balance = 1000)
      @balance = balance
      @deck = Deck.new
      @step = :betting
      @player_hands = [] #Needs to be an array.
      @dealer_hand = Hand.new
      @active_hand = 0
      @message = "Place your bet!" # This message will change depending on the state and if there are errors.
      @results = []
    end

    def place_bet(wager)
        return error('Not in betting phase') unless step == :betting

        wager = wager.to_i
        return error('Invalid bet wager') if wager <= 0 || wager > balance

        @balance -= wager
        hand = Hand.new(wager) #This is the initial deal.
        @player_hands << hand # Put hand into array
        deal_initial
        @step = :player_turn #Need to check balance to see if split possible.
        @message = change_message
    end

    def double_down
        return error("Not player turn.") unless step == :player_turn
        return error("Can only double with 2 cards in hand.") unless current_hand.cards.size == 2
        return error("Not enough money to double.") if balance < current_hand.bet

        @balance -= current_hand.bet
        current_hand.bet *= 2
        current_hand.add(deck.deal)
        @message = "Doubled! Score: #{current_hand.score}."

        if current_hand.busted?
            current_hand.busted = true
        end
        current_hand.done = true
        next_hand
    end

    def split
        return error('Not player turn') unless step == :player_turn
        return error('Cannot split this hand') unless current_hand.splittable?
        return error('Insufficient balance') if balance < current_hand.bet

        @balance -= current_hand.bet

        split_card = current_hand.cards.pop # Grabs the second card

        new_hand = Hand.new(current_hand.bet)
        new_hand.add(split_card) # place second card in new hand

        current_hand.add(deck.deal) #Deal a card to both hands.
        new_hand.add(deck.deal)

        player_hands.insert(active_hand + 1, new_hand) # used this because the first hand could split a second time.

        if current_hand.cards.first.rank == 'A' #"Split Aces rule"
            current_hand.done = true
            new_hand.done     = true
            next_hand
        end
    end

    def hit # Need to be able to handle multiple hands, so do this per hand.
        return error("Please wait for your turn to hit.")  unless step == :player_turn
        current_hand.add(deck.deal)
        if current_hand.busted?
            current_hand.busted = true
            current_hand.done = true
            @message = "Bust on hand #{active_hand + 1}. (#{current_hand.score})"
            next_hand
        else
            @message = "Hit. Score: (#{current_hand.score})"
        end
    end

    def stand # Need to be able to handle multiple hands, so do this per hand.
        return error("Please wait for your turn to stand.") unless step == :player_turn
        current_hand.stood = true
        current_hand.done = true
        @message = "Stand on hand #{active_hand + 1} (#{current_hand.score})"
        next_hand
    end

    def dealer_turn #Dealer able to split?
        return error("Not dealer turn") unless step == :dealer_turn

        while dealer_hand.score < 17
            dealer_hand.add(deck.deal)
            if dealer_hand.cards.size == 5
                break
            end
        end

        @step = :game_over
        get_results
    end
    
    def to_h
        {
            deck: deck.to_a,
            player_hands: player_hands.map(&:to_h),
            active_hand: active_hand,
            dealer_hand: dealer_hand.to_h,
            step: step.to_s,
            balance: balance,
            message: message,
            results: results
        }
    end
    
    def self.from_h(h)
        game = allocate
        game.deck = Deck.from_a(h['deck'] || [])
        game.player_hands = (h['player_hands'] || []).map { |player_hand| Hand.from_h(player_hand) }
        game.dealer_hand = Hand.from_h(h['dealer_hand'] || {})
        game.step = (h['step'] || 'betting').to_sym
        game.balance = h['balance'] || 1000
        game.message = h['message'] || ''
        game.active_hand = h['active_hand'] || 0
        game.results = h['results'] || []
        game
    end
    
    private
        def deal_initial
            2.times { player_hands.first.add(deck.deal) }
            2.times { dealer_hand.add(deck.deal) }
        end

        def get_results #Find a way to loop through the hands to be able to handle multiple wins, losses, and pushes.
            @step = :game_over
            @results = []
            player_hands.each_with_index do | hand, index |
                dealer_score = dealer_hand.score
                player_score = hand.score
                dealer_bust = dealer_hand.busted?
            
                hand_result = 
                    if hand.blackjack? && !dealer_hand.blackjack?
                        @balance += (hand.bet * 2.5).to_i
                        @message = "Hand #{index + 1}: Blackjack! You win! Earned $#{(hand.bet * 1.5).to_i}!"
                    elsif hand.busted?
                        @message = "Hand #{index + 1}: Bust! Lost $#{hand.bet} Try again."
                    elsif dealer_hand.busted? || hand.score > dealer_hand.score
                        @balance += hand.bet * 2
                        @message = "Hand #{index + 1}: You win! Earned $#{hand.bet}!"
                    elsif hand.score == dealer_hand.score
                        @balance += hand.bet
                        @message = "Hand #{index + 1}: Push. Money back."
                    else
                        @message = "Hand #{index + 1}: Dealer wins. Lost $#{hand.bet}."
                    end
                @results << hand_result
            end
            @message = results.join(" | ")
        end

        def current_hand
            player_hands[active_hand]
        end

        def next_hand
            next_index = (active_hand + 1...player_hands.size).find do |i|
                !player_hands[i].done
            end

            if next_index
                @active_hand = next_index
                else
                    @step = :dealer_turn
                    dealer_turn
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