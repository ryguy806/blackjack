module GameHelper
    RED_SUITS = %w[H D].freeze

  def render_card(card, hidden: false)
    if hidden
      content_tag(:div, class: 'card hidden') { '?' }
    else
      color = RED_SUITS.include?(card[:suit] || card['suit']) ? 'red' : 'black'
      rank  = card[:rank] || card['rank']
      suit  = card[:suit] || card['suit']
      content_tag(:div, class: "card #{color}") do
        content_tag(:span, rank, class: 'rank') +
          content_tag(:span, suit, class: 'suit')
      end
    end
  end
    
    def hand_score_display(hand_h, hide_second: false)
        return '?' if hide_second
        cards = hand_h[:cards] || hand_h['cards'] || []
        return '?' if cards.empty?
        Hand.from_h(hand_h).score
    end
end
