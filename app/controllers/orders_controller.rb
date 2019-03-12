class OrdersController < ApplicationController
  def index
    @places = Place.all
  end

  def new_order
    @place = Place.find(params[:id])
    session[:place] = @place
  end

  def create
    session[:order] = {}
    params[:order].permit!
    fill_order
    save_list_of_participants
  end

  def finish
    price = params[:price]['price'].to_i
    price_by_person = {}
    sum_of_all_varieties = session[:order]['sum_of_all_varieties']
    sum_of_varieties_by_person = session[:order]['sum_of_varieties_by_person']
    price_per_unit = price / sum_of_all_varieties
    sum_of_varieties_by_person.each do |person, quantity|
      price_by_person[person] = price_per_unit * sum_of_varieties_by_person[person]
    end
    session[:order]['price_by_person'] = price_by_person
  end

  private

  def fill_order
    varieties_to_buy = []
    order = Order.new
    params[:order][:q].to_h.map do |person_id, varieties_chosen|
      person_name = params[:order]['name'][person_id]
      varieties_chosen.map do |variety_id, quantity|
        variety_name = (Variety.find(variety_id)).name
        if quantity.to_i > 0
          order_detail = OrderDetail.new(person_name, variety_name, quantity.to_i)
          order.order_details << order_detail
          varieties_to_buy << variety_name
        end
      end
    end
    session[:order] = order
    session[:varieties_to_buy] = varieties_to_buy.uniq
  end

  def save_list_of_participants
    participants = params[:order][:name].to_h.values
    participants.reject! { |p| p.empty? }
    session[:order_participants] = participants
  end

end
