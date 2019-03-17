class OrdersController < ApplicationController
  def index
    @places = Place.all
  end

  def new
    @order = Order.new
    place = Place.find(params[:place_id])
    @order.place_id = place.id
    @order.save
  end

  def create
    @order = fill_order
    redirect_to order_path(@order.id)
  end

  def show
    @order = Order.find(params[:id])
  end

  def finish
    @order = Order.find(params[:order_data][:id])
    @order.price = params[:order_data]['price'].to_i
  end

  private

  def fill_order
    params[:order_new].permit!
    order = Order.find(params[:order_id])
    params[:order_new]['q'].to_h.map do |person_id, varieties_chosen|
      person_name = params[:order_new]['name'][person_id]
      varieties_chosen.map do |variety_id, quantity|
        variety = Variety.find(variety_id)
        if quantity.to_i > 0 
          unless person_name.empty?
            OrderDetail.create(person: person_name, order_id: order.id, variety_id: variety.id, quantity: quantity.to_i)
          else
            OrderDetail.create(person: 'Other', order_id: order.id, variety_id: variety.id, quantity: quantity.to_i)
          end
        end
      end
    end
    order
  end
end
