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

  def calculate_waiting_time(created_date,board)
    waiting_time = 0
    moviments  = @moviments.clone
    moviments = moviments.sort {|m| m.date}
    start_date = created_date
    moviments.each_with_index do |moviment, index|
      if board.is_waiting_list?(moviment.from)
        if start_date.nil?
          start_date = moviment.date
        else
          waiting_time += (moviment.date.to_f - start_date.to_f) 
        end
      else
        start_date = nil 
      end
    end
    get_days_from_seconds(waiting_time)
  end

  def calculate_working_time(board)
    working_time = 0
    moviments  = @moviments.clone
    moviments = moviments.sort {|m| m.date}
    start_date = nil
    moviments.each_with_index do |moviment, index|
      if board.is_working_list?(moviment.to)
        start_date = moviment.date
      else
        unless start_date.nil?
          working_time += (moviment.date.to_f - start_date.to_f) 
          start_date = nil
        end 
      end
    end
    get_days_from_seconds(working_time)
  end

  private

  def get_days_from_seconds(seconds)
    return 0 if seconds.nil? 
    (seconds / 86400).floor
  end


end