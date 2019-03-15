class OrdersController < ApplicationController
  def index
    @places = Place.all
  end

  def new
    @order = Order.new
    @place = Place.find(params[:place_id])
  end

  def create
    params[:order].permit!
    @order = fill_order
  end

  def finish
    @order = fill_order
    @order.price = params[:price]['price'].to_i
  end

  private

  def fill_order
    place = params[:order][:id]
    order = Order.create
    params[:order]['q'].map do |person_id, varieties_chosen|
      person_name = params[:order]['name'][person_id]
      varieties_chosen.map do |variety_id, quantity|
        variety = Variety.find(variety_id)
        if quantity.to_i > 0 
          unless person_name.empty?
           OrderDetail.create(name: person_name, variety: variety, quantity: quantity.to_i, order: order)
          else
            OrderDetail.create('Others', variety_name, quantity.to_i)
          end
        end
      end
    end
    order
  end

end
