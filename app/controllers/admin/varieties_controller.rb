class Admin::VarietiesController < ApplicationController

  http_basic_authenticate_with name: ENV['ID'], password: ENV['KEY']

  def new
    @place = Place.find(params[:place_id])
    @variety = Variety.new
  end

  def create
    @variety = Variety.new(variety_params)
    place = Place.find(params[:place_id])
    @variety.place = place
    if @variety.save
      redirect_to admin_place_path(place.id)
    else
      render 'new'
    end
  end

  def edit
    @variety = Variety.find(params[:id])
  end

  def update
    @variety = Variety.find(params[:id])
    if @variety.update(variety_params)
      redirect_to admin_place_path(@variety.place_id)
    else
      render 'edit'
    end
  end

  def destroy
    @variety = Variety.find(params[:id])
    @variety.destroy
    redirect_to admin_place_path(@variety.place_id)
  end

  private
  def variety_params
    params.require(:variety).permit(:name)
  end
end
