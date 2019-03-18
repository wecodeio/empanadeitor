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
    @place = Place.find_by(id: params[:id])
    if !@place
      redirect_to admin_places_path
    end
  end

  def edit
    @place = Place.find_by(id: params[:id])
    if !@place
      redirect_to admin_places_path
    end
  end

  def update
    @place = Place.find_by(id: params[:id])
    if !@place
      redirect_to admin_places_path
    else
      @place.update(place_params)
      redirect_to admin_places_path
    end
  end

  def destroy
    @place = Place.find_by(id: params[:id])
    if !@place
      redirect_to admin_places_path
    else
      @place.destroy
      redirect_to admin_places_path
    end
  end

  private

  def place_params
    params.require(:place).permit(:name, :phone, :address)
  end
end
