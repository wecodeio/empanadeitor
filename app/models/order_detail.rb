class OrderDetail

  attr_reader :person, :variety, :quantity
  attr_accessor :price
  
  def initialize(person, variety, quantity)
    @person = person
    @variety = variety
    @quantity = quantity
    @price = 0.0
  end
  
end