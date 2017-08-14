require_relative 'card'

class Board

  def initialize(trello_board, done_card, lead_time_cards)
    @trello_board = trello_board
    @done_card = done_card
    @lead_time_cards = lead_time_cards
  end

  def done_cards
    list = get_done_list
    list.cards.map do |trello_card|
      Card.new(trello_card,@lead_time_cards)      
    end
  end

  def get_done_list
    @trello_board.lists.each do |list| 
      if list.name == @done_card
        return list
      end
    end
  end

end