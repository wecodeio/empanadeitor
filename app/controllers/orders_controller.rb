class OrdersController < ApplicationController
  def index
    @places = Place.all
  end

  def new
    @order = Order.new
    @place = Place.find(params[:place_id])
    @order.place_name = @place.name
  end

  def create
    @order = fill_order
    place = Place.find(params[:place_id])
    @order.place_name = place.name
    @order.place_address = place.address
    @order.place_phone = place.phone
    @order.save
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
    order = Order.new
    params[:order_new].permit!
    params[:order_new]['q'].to_h.map do |person_id, varieties_chosen|
      person_name = params[:order_new]['name'][person_id].presence || 'Others'
      varieties_chosen.map do |variety_id, quantity|
        variety = Variety.find(variety_id)
        if quantity.to_i > 0
            order.order_details << OrderDetail.new(person: person_name, order_id: order.id, variety_name: variety.name, quantity: quantity.to_i)
        end
      end
    end
    order
  end
end
