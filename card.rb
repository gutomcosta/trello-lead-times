require_relative 'moviments'

class Card
  attr_reader :trello_card

  def initialize(trello_card, board)
    @trello_card = trello_card
    @board = board
    @moviments = Moviments.new
  end


  def to_hash
    binding.pry

    created_at = get_card_created_info
    moviments = get_card_moviments
    last_moviment = moviments.first
    puts last_moviment.inspect
    if last_moviment.nil?
      last_moviment = moviments.no_movimens
    end
    {
      name: @trello_card.name,
      created_at: created_at[:date],
      start_list: created_at[:list],
      finished_at: last_moviment.date || "",
      finish_list: last_moviment.to || "",  
      seconds: get_seconds(created_at[:date], last_moviment.date),
      days: get_days(created_at[:date], last_moviment.date),
      labels: get_labels(),
      week: get_week_num(last_moviment.date),
      cycle_time_days: get_days(created_at[:date], get_cycle_time.date),
      waiting_time: get_waiting_time
    }
  
  end

  def print_list_historic
    created_at = get_card_created_info
    moviments = get_card_moviments
    puts "card: #{@trello_card.name} - created at: #{created_at[:date]} in #{created_at[:list]} - moviments:"
    moviments.all.each do |moviment|
      puts "         #{moviment.to_s}"
    end 
  end



  def get_waiting_time
  
  end

  def get_cycle_time
    moviments = get_card_moviments
    moviment = moviments.get_moviment_of(list_name: @board.cycle_time_list)
    return moviments.no_moviment if moviment.nil?
    # moviments.each do |moviment|
    #   return moviment[:date] if moviment[:to]["name"] == @board.cycle_time_list
    # end
    return moviment
  end

  def get_week_num(finish)
    return 0 if (not finish.present?)
    datetime = DateTime.parse(finish.to_s)
    datetime.cweek
  end

  def get_labels
    labels = @trello_card.labels.map {|l| l.name}
    labels.join(',')
  end

  def get_seconds(start,finish)
    return 0 if (not start.present?) or (not finish.present?)
    (finish.to_f - start.to_f)
  end

  def get_days(start,finish)
   days =  (get_seconds(start, finish) / 86400).floor
    sprintf('%.2f', days)
  end
  
  def get_card_created_info
    actions =  get_actions
    actions.each do |action|
      if action.type == "createCard" or action.type == "convertToCardFromCheckItem" 
        return {
          list: action.data["list"]["name"],
          date: action.date
        }        
      end
    end
    action = actions.last
    list = action.data.include?("list") ? action.data["list"]["name"] : ""
    {
      list: list,
      date: action.date
    }      
  end

  def get_card_moviments
    moviments = []
    get_actions.each do |action|
      if action.type == "updateCard" || action.type == 'createCard'
        if action.data.include?("listBefore")
          @moviments.register_moviment(
            from: action.data["listBefore"],
            to: action.data["listAfter"],
            date: action.date 
          )
          # moviments << {
          #   from: action.data["listBefore"],
          #   to: action.data["listAfter"],
          #   date: action.date 
          # }
        end
      end
    end
    @moviments
  end

  def get_actions
    actions = @trello_card.actions.sort {|a| a.date }
    actions.reverse
  end

end