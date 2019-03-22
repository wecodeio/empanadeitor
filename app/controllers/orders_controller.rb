class OrdersController < ApplicationController
  def index
    @places = Place.all
  end

  def new
    @place = Place.find(params[:place_id])
    @order = Order.new(place: @place)
    @order.set_place= @place
    @order.save
    redirect_to edit_order_path(@order.id)
  end

  def edit
    @order = Order.find_by(id: params[:id])
  end

  def new_custom_place
    @order = Order.new
    @order.place_name = params[:custom_place][:name]
    @order.save
    redirect_to edit_custom_place_order_path(@order.id)
  end

  def edit_custom_place
    @order = Order.find_by(id: params[:id])
  end

  def create
    fill_order
    redirect_to confirm_order_path(@order.id)
  end

  def confirm
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
