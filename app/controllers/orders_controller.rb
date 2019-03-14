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
  end

  def finish
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
          unless person_name.empty?
            order_detail = OrderDetail.new(person_name, variety_name, quantity.to_i)
          else
            order_detail = OrderDetail.new('Others', variety_name, quantity.to_i)
          end  
            order.add_order_detail(order_detail)
        end
      end
    end
    order
  end

end
