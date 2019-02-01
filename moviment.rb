class Moviment
  attr_reader :from, :to, :date

  def initialize(from:, to:, date:)
    @from = from
    @to = to
    @date = date
  end

  def to_s
    "from #{self.from} to #{self.to} at #{self.date}"
  end
end