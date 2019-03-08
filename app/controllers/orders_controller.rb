class OrdersController < ApplicationController
  def index
    @places = Place.all
  end

  def newOrder
    @place = Place.find(params[:id])
  end

  def create
    total_order
    order_by_person
  end

  private

  def order_by_person
    @total_order_by_person = {}
    params[:order][:q].to_h.map do |variety_id, order_for_variety|
      variety_name = Variety.find(variety_id).name
      @total_order_by_person[variety_name] = {}
      order_for_variety.each do |persona, cantidad|
        @total_order_by_person[variety_name][params[:order]['name'][persona]] = cantidad.to_i
      end
    end
  end

  def total_order
    params.require(:order).permit!
    @total_order = []
    #params[:order][:q].to_h.map {|k, v| totales_por_empanada[k.to_i] = v.values.map {|c| c.to_i}.sum}
    params[:order][:q].to_h.map do |variety_id, order_for_variety|
      total_per_variety = {}
      total_per_variety['variety'] = Variety.find(variety_id)
      total_per_variety['quantity'] = order_for_variety.values.map {|c| c.to_i}.sum
      @total_order << total_per_variety
    end
  end

end
