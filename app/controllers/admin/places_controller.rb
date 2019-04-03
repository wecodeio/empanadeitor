class Admin::PlacesController < Admin::BaseController

  def index
    @places = Place.all
  end

  def new
    @place = Place.new
  end

  def create
    @place = Place.new(place_params)
    if @place.save
      flash[:success] = I18n.t('activerecord.messages.create_place') + " #{@place.name}"
      redirect_to admin_places_path
    else
      render 'new'
    end
  end

  def show
    @place = Place.find_by(id: params[:id])
    if !@place
      flash[:danger] = I18n.t('activerecord.errors.messages.url')
      redirect_to admin_places_path
    end
  end

  def edit
    @place = Place.find_by(id: params[:id])
    if !@place
      flash[:danger] = I18n.t('activerecord.errors.messages.url')
      redirect_to admin_places_path
    end
  end

  def update
    @place = Place.find_by(id: params[:id])
    if !@place
      flash[:danger] = I18n.t('activerecord.errors.messages.url')
      redirect_to admin_places_path
    else
      if @place.update(place_params)
        flash[:success] = I18n.t('activerecord.messages.update_place') + " #{@place.name}"
        redirect_to admin_places_path
      else
        render 'edit'
      end
    end
  end

  def destroy
    @place = Place.find_by(id: params[:id])
    if !@place
      flash[:danger] = I18n.t('activerecord.errors.messages.url')
    else
      if @place.destroy
        flash[:success] = I18n.t('activerecord.messages.delete_place') + " #{@place.name}"
      else 
        flash[:danger] = I18n.t('activerecord.errors.messages.delete_place') + " #{@place.name}"
      end
    redirect_to admin_places_path
    end
  end

  private

  def place_params
    params.require(:place).permit(:name, :phone, :address)
  end

end
