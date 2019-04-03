class Admin::VarietiesController < Admin::BaseController

  def new
    @place = Place.find_by(id: params[:place_id])
    if !@place
      flash[:danger] = I18n.t('activerecord.errors.messages.url')
      redirect_to admin_places_path
    end
    @variety = Variety.new
  end

  def create
    place = Place.find_by(id: params[:place_id])
    if !place
      flash[:danger] = I18n.t('activerecord.errors.messages.url')
      redirect_to places_path
    end
    @variety = Variety.new(variety_params)
    @variety.place = place
    if @variety.save
      flash[:success] = I18n.t('activerecord.messages.create_variety') + " #{@variety.name}"
      redirect_to admin_place_path(place.id)
    else
      render 'new'
    end
  end

  def edit
    @variety = Variety.find_by(id: params[:id], place_id: params[:place_id])
    if !@variety
      flash[:danger] = I18n.t('activerecord.errors.messages.url')
      redirect_to admin_places_path
    end
  end

  def update
    @variety = Variety.find_by(id: params[:id])
    if !@variety
      flash[:danger] = I18n.t('activerecord.errors.messages.url')
      redirect_to admin_places_path
    end
    if @variety.update(variety_params)
      flash[:success] = I18n.t('activerecord.messages.update_variety') + " #{@variety.name}"
      redirect_to admin_place_path(@variety.place_id)
    else
      render 'edit'
    end
  end

  def destroy
    @variety = Variety.find_by(id: params[:id])
    if !@variety
      flash[:danger] = I18n.t('activerecord.errors.messages.url')
      redirect_to admin_places_path
    end
    if @variety.destroy
      flash[:success] = I18n.t('activerecord.messages.delete_variety') + " #{@variety.name}"
    else
      flash[:danger] = I18n.t('activerecord.errors.messages.delete_variety') + " #{@variety.name}"
    end
    redirect_to admin_place_path(@variety.place_id)
  end

  private
  def variety_params
    params.require(:variety).permit(:name)
  end
end
