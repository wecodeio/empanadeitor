class PlacesController < ApplicationController

  def index
    @places = Place.all
  end

  def new
    @place = Place.new
  end

  def create
    @place = Place.new(place_params)
    if @place.save
      redirect_to place_path
    else
      render 'new'
    end
  end

  def show
    @place = Place.find(params[:id])
  end

  private
  def place_params
    params.require(:place).permit(:name, :phone, :address)
  end
end
