require 'trello'
require 'pry'
require 'pry-byebug'
require 'csv'

require_relative 'board'


class TrelloAnalysis

  TRELLO_DEVELOPER_PUBLIC_KEY       = 'ec8c53a4f7f25c2481b27914472ceea1'
  TRELLO_MEMBER_TOKEN               = '4977dcf8ec222ce860d4494414d238ac6de7984b9616ff16151c3638735388e0'



  def initialize
        
    Trello.configure do |trello|
      trello.developer_public_key = TRELLO_DEVELOPER_PUBLIC_KEY
      trello.member_token = TRELLO_MEMBER_TOKEN
    end
  end


  def analyze
    trello_board = get_board('Beep Fluxo Unificado - Agendamento nos Apps')
    lead_time_cards = ['comprometido', 'em andamento', 'aguardando deploy']
    if trello_board 
      binding.pry
      board = Board.new(trello_board, 'aguardando deploy', lead_time_cards)
      cards = board.done_cards
      data = cards.map {|card| card.to_hash }
      save_to_csv(data)

    end
  end

  def save_to_csv(data)
    CSV.open('trello.csv', 'wb', {col_sep: ';'}) do |csv|
      data.each do |hash|
        csv << hash.values
      end
    end
  end

  def get_board(name)
    board = Trello::Board.all.detect do |board|
      board.name == name
    end
    board
  end


end
