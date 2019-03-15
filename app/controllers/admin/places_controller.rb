class Admin::PlacesController < ApplicationController

  http_basic_authenticate_with name: ENV['ID'], password: ENV['KEY']
  layout 'admin_application'

  def index
    @places = Place.all
  end

  def new
    @place = Place.new
  end
  
  def create
    @place = Place.new(place_params)
    if @place.save
      redirect_to admin_places_path
    else
      render 'new'
    end
  end

  def show
    @place = Place.find(params[:id])
  end

  def edit
    @place = Place.find(params[:id])
  end

  def update
    @place = Place.find(params[:id])
    @place.update(place_params)
    redirect_to admin_places_path
  end

  def destroy
    @place = Place.find(params[:id])
    @place.destroy
    redirect_to admin_places_path
  end

  private
  def place_params
    params.require(:place).permit(:name, :phone, :address)
  end
end
