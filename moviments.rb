require_relative 'moviment'

class Moviments
  
  def initialize
    @moviments = []
  end

  def register_moviment(from:, to:, date:)
    @moviments << Moviment.new(from: from['name'], to: to['name'], date: date)
  end

  def get_moviment_of(list_name:)
    @moviments.select {|m| m.to == list_name }.first
  end 

  def first
    @moviments.first
  end

  def no_moviment
    Moviment.new(from: '', to: '', date: '')
  end

  def all
    @moviments
  end


end