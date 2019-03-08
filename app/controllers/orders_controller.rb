class OrdersController < ApplicationController
  def index
    @places = Place.all
  end

  def newOrder
    @place = Place.find(params[:id])
  end

  def create
    params.require(:order).permit!
    total_order = []
    #params[:order][:q].to_h.map {|k, v| totales_por_empanada[k.to_i] = v.values.map {|c| c.to_i}.sum}
    params[:order][:q].to_h.map do |variety_id, order_for_variety|
      total_per_variety = {}
      total_per_variety['variety'] = variety_id
      total_per_variety['quantity'] = order_for_variety.values.map {|c| c.to_i}.sum
      total_order << total_per_variety
    end
    byebug
  end
end
