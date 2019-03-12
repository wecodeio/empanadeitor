class Order

  attr_reader :order_details, :price
  attr_accessor :order_details, :price

  def initialize
    @order_details = []
    @price = 0.0
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

end