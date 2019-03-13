class Order

  attr_reader :order_details
  attr_accessor :price

  def initialize
    @order_details = []
    @price = 0.0
  end

  def add_order_detail(order_detail)
    order_details << order_detail
  end

  def total_units_per_variety
    total_units_per_variety = Hash.new(0)
    @order_details.each do |detail|
      total_units_per_variety[detail.variety] += detail.quantity
    end
    total_units_per_variety
  end
  
  def total_units
    total_units_per_variety.values.sum
  end

  def total_units_per_person
    total_units_per_person = Hash.new(0)
    @order_details.each do |detail|
      total_units_per_person[detail.person] += detail.quantity
    end
    total_units_per_person
  end

  def price_per_person
    load_prices
    price_per_person = Hash.new(0)
    order_details.each do |detail|
      price_per_person[detail.person] += detail.price
    end
    price_per_person
  end

  def load_prices
    price_per_unit = @price / total_units
    order_details.each do |detail|
      detail.price = detail.quantity * price_per_unit
    end
  end

end