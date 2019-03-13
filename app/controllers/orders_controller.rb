class OrdersController < ApplicationController
  def index
    @places = Place.all
  end

  def new_order
    @place = Place.find(params[:id])
    session[:place] = @place
  end

  def create
    params[:order].permit!
    session[:input_user] = params[:order].to_h
    @order = fill_order
    save_list_of_participants
    
  end

  def finish
    @price_by_person = {}
    @order = fill_order
    @order.price = params[:price]['price'].to_i
  end

  private

  def fill_order
    varieties_to_buy = []
    order = Order.new
    session[:input_user]['q'].map do |person_id, varieties_chosen|
      person_name = session[:input_user]['name'][person_id]
      varieties_chosen.map do |variety_id, quantity|
        variety_name = (Variety.find(variety_id)).name
        if quantity.to_i > 0
          order_detail = OrderDetail.new(person_name, variety_name, quantity.to_i)
          order.add_order_detail(order_detail)
          varieties_to_buy << variety_name
        end
      end
    end
    session[:varieties_to_buy] = varieties_to_buy.uniq
    order
  end

  def save_list_of_participants
    participants = params[:order][:name].to_h.values
    participants.reject! { |p| p.empty? }
    session[:order_participants] = participants
  end

end
