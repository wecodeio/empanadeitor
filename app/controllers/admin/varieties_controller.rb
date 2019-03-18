class Admin::VarietiesController < ApplicationController

  http_basic_authenticate_with name: ENV['ID'], password: ENV['KEY']
  layout 'admin_application'

  def new
    @place = Place.find_by(id: params[:place_id])
    if !@place
      redirect_to admin_places_path
    end
    @variety = Variety.new
  end

  def create
    place = Place.find_by(id: params[:place_id])
    if !place
      redirect_to places_path
    end
    @variety = Variety.new(variety_params)
    @variety.place = place
    if @variety.save
      redirect_to admin_place_path(place.id)
    else
      render 'new'
    end
  end

  def edit
    @variety = Variety.find_by(id: params[:id], place_id: params[:place_id])
    if !@variety
      redirect_to admin_places_path
    end
  end

  def update
    @variety = Variety.find_by(id: params[:id])
    if !@variety
      redirect_to admin_places_path
    end
    if @variety.update(variety_params)
      redirect_to admin_place_path(@variety.place_id)
    else
      render 'edit'
    end
  end

  def destroy
    @variety = Variety.find_by(id: params[:id])
    if !@variety
      redirect_to admin_places_path
    end
    @variety.destroy
    redirect_to admin_place_path(@variety.place_id)
  end

  private
  def variety_params
    params.require(:variety).permit(:name)
  end
end
