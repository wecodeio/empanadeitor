class OrdersController < ApplicationController
  def index
    @places = Place.all
  end

  def new
    @place = Place.find(params[:place_id])
    @order = Order.create(place: @place)
    @order.set_place = @place
    @order.save
    redirect_to edit_order_path(@order.id)
  end

  def edit
    @order = Order.find_by(id: params[:id])
  end

  def new_custom_place
    @order = Order.create
    @order.place_name = params[:custom_place][:name]
    @order.save
    redirect_to edit_custom_place_order_path(@order.id)
  end

  def edit_custom_place
    @order = Order.find_by(id: params[:id])
  end

  def create
    fill_order(params[:order_id])
    if params[:commit] == "Guardar"
      redirect_to edit_order_path(@order.id)
    else
      redirect_to confirm_order_path(@order)
    end
  end

  def create_custom_place
    fill_order(params[:order_id])
    if params[:commit] == "Guardar"
      redirect_to edit_custom_place_order_path(@order.id)
    else
      redirect_to confirm_order_path(@order)
    end
  end

  def confirm
    @order = Order.find(params[:id])
  end

  def finish
    @order = Order.find(params[:id])
    @order.price = params[:order_data]['price'].to_i
  end

  private

  def fill_order(order_id)
    @order = Order.find(order_id)
    params[:input_order].permit!
    params[:input_order]['q'].to_h.map do |person_id, varieties_chosen|
      person_name = params[:input_order]['name'][person_id]
      varieties_chosen.map do |variety_id, quantity|
        if @order.place_id
          variety = Variety.find_by(id: variety_id)
          variety_name = variety.name
        else
          variety_name = params[:input_order][:variety][variety_id.to_s]
        end
        detail = @order.order_details.find_by(person: person_name, variety_name: variety_name)
        if detail
          if quantity.to_i == 0
            detail.destroy
          else
            detail.update(quantity: quantity.to_i)
          end
        else
          if quantity.to_i != 0
            @order.order_details << OrderDetail.new(person: person_name, order_id: @order.id, quantity: quantity.to_i, variety_name: variety_name)
          end
        end
      end
    end
    @order.save
  end
end
