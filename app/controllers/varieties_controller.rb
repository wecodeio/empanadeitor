class VarietiesController < ApplicationController

  def new
    @places = Place.all
    @variety = Variety.new
  end

  def create
    @variety = Variety.new(variety_params)
    if @variety.save
      redirect_to variety_path
    else
      render 'new'
    end
  end

  private
  def variety_params
    params.require(:variety).permit(:name, :price, :place_id)
  end
end
