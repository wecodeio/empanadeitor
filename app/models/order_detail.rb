class OrderDetail
  attr_reader :person, :variety, :quantity, :price
  attr_accessor :person, :variety, :quantity, :price

  def initialize(person, variety, quantity)
    @person = person
    @variety = variety
    @quantity = quantity
    @price = 0.0
  end
end