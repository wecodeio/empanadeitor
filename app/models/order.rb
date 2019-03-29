class Order < ApplicationRecord

  has_many :order_details
  belongs_to :place, optional: true

  after_create do
    self.slug = Time.now.to_i.to_s(36).upcase
    self.open = true
  end

  def set_place= place
    self.place_name = place.name
    self.place_address = place.address
    self.place_phone = place.phone
  end

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

  def varieties_to_buy 
    varieties_to_buy =[]
    self.order_details.each do |detail|
      varieties_to_buy << detail.variety_name
    end
    varieties_to_buy.uniq
  end

  def quantity_participants
    list_of_participants.length
  end

  def search_quantity(person_name, variety_name)
    detail = self.order_details.find_by(person: person_name, variety_name: variety_name)
    if detail
      quantity=detail.quantity
    else
      quantity=0
    end
  end

  def was_ordered?
    self.price > 0
  end

  def status
    if was_ordered?
      response = 'finalizada'
    elsif !self.open
      response = 'cerrada'
    else
      response = 'en curso'
    end
    response
  end
end
