require_relative 'card'

class Board
  attr_reader :lead_time_cards, :cycle_time_list, :waiting_lists, :work_lists

  def initialize(trello_board:, done_card:, lead_time_cards:, cycle_time_list:, waiting_lists:, work_lists:)
    @trello_board = trello_board
    @done_card = done_card
    @lead_time_cards = lead_time_cards
    @cycle_time_list = cycle_time_list
    @waiting_lists = waiting_lists
    @work_lists = work_lists
  end

  def done_cards
    list = get_done_list
    list.cards.map do |trello_card|
      Card.new(trello_card,self)
    end
  end

  def get_done_list
    @trello_board.lists.each do |list| 
      if list.name == @done_card
        return list
      end
    end
  end

  def is_waiting_list?(list_name)
    @waiting_lists.any? {|name| name==list_name}
  end
  
  def is_working_list?(list_name)
    @work_lists.any? {|name| name==list_name}
  end

  def is_done_list(list_name)
    done_card == list_name
  end
end