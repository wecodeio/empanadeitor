class OrdersController < ApplicationController
  def index
    @places = Place.all
  end

  def new
    @order = Order.new
    if params[:place_id]
      @place = Place.find(params[:place_id])
      @order.place_name = @place.name
      @order.place_address = @place.address
      @order.place_phone = @place.phone
      @order.save
    else
      @order.place_name = params[:custom_place][:name]
      @order.save
      render 'new_custom_place'
    end
  end

  def create
    fill_order
    redirect_to order_path(@order.id)
  end

  def show
    @order = Order.find(params[:id])
  end

  def finish
    @order = Order.find(params[:id])
    @order.price = params[:order_data]['price'].to_i
  end

  private

  def fill_order
    @order = Order.find(params[:order_id])
    params[:input_order].permit!
    params[:input_order]['q'].to_h.map do |person_id, varieties_chosen|
      person_name = params[:input_order]['name'][person_id].presence || 'Others'
      varieties_chosen.map do |variety_id, quantity|
        variety = Variety.find_by(id: variety_id)
        if variety && variety.place.name == @order.place_name
          variety_name = variety.name
        else
          variety_name = params[:input_order][:variety][variety_id.to_s]
        end
        if quantity.to_i > 0
            @order.order_details << OrderDetail.new(person: person_name, order_id: @order.id, variety_name: variety_name, quantity: quantity.to_i)
        end
      end
    end
    @order.save
  end
end
