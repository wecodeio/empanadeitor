class Order < ApplicationRecord

  has_many :order_details

  def total_units_per_variety
    total_units_per_variety = Hash.new(0)
    self.order_details.each do |detail|
      total_units_per_variety[detail.variety_name] += detail.quantity
    end
    total_units_per_variety
  end
  
  def total_units
    total_units_per_variety.values.sum
  end

  def total_units_per_person
    total_units_per_person = Hash.new(0)
    self.order_details.each do |detail|
        total_units_per_person[detail.person] += detail.quantity
    end
    total_units_per_person
  end

  def price_per_person
    load_prices
    price_per_person = Hash.new(0)
    self.order_details.each do |detail|
        price_per_person[detail.person] += detail.price
    end
    price_per_person
  end

  def load_prices
    price_per_unit = self.price / total_units
    self.order_details.each do |detail|
      detail.price = detail.quantity * price_per_unit
    end
  end

  def list_of_participants
    participants = []
    self.order_details.each do |detail|
        participants << detail.person
    end 
    participants.uniq
  end

  def  varieties_to_buy 
    varieties_to_buy =[]
    self.order_details.each do |detail|
      varieties_to_buy << detail.variety_name
    end
    varieties_to_buy.uniq
  end

end
