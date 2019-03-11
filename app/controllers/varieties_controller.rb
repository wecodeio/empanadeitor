class VarietiesController < ApplicationController

  def index
    @varieties = Variety.all
  end

  def new
    @places = Place.all
    @variety = Variety.new
  end

  def create
    @variety = Variety.new(variety_params)
    if @variety.save
      redirect_to varieties_path
    else
      @places = Place.all
      render 'new'
    end
  end

  def edit
    @places = Place.all
    @variety = Variety.find(params[:id])
  end

  def update
    @variety = Variety.find(params[:id])
    if @variety.update(variety_params)
      redirect_to varieties_path
    else
      @places = Place.all
      render 'edit'
    end
  end

  def destroy
    @variety = Variety.find(params[:id])
    @variety.destroy
    redirect_to varieties_path
  end

  private
  def variety_params
    params.require(:variety).permit(:name, :price, :place_id)
  end
end
