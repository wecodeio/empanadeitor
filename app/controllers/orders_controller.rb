class OrdersController < ApplicationController
  def index
    @places = Place.all
  end

  def new
    @place = Place.find(params[:place_id])
    @order = Order.create(place: @place)
    @order.set_place = @place
    @order.save
    redirect_to edit_order_path(@order.id)
  end

  def new_custom_place
    @order = Order.create
    @order.place_name = params[:custom_place][:name]
    @order.save
    redirect_to edit_order_path(@order.id)
  end

  def create
    fill_order(params[:order_id])
    if params[:commit] == "Guardar"
      redirect_to edit_order_path(@order.id)
    else
      @order.update(open: false)
      redirect_to confirm_order_path(@order)
    end
  end

  def create_custom_place
    fill_order(params[:order_id])
    if params[:commit] == "Guardar"
      redirect_to edit_custom_place_order_path(@order.id)
    else
      redirect_to confirm_order_path(@order)
    end
  end

  def edit
    @order = Order.find_by(id: params[:id])
    if @order.place_id
      edit_existing_place(@order)
    else
      edit_custom_place(@order)
    end
  end

  def edit_existing_place(order)
    render 'edit'
    @order = order
    if !@order
      redirect_to orders_path
    else
      if @order.was_ordered?
        flash[:info] = 'El pedido ya fue realizado'
        redirect_to orders_path
      end
    end
  end

  def edit_custom_place(order)
    render 'edit_custom_place'
    @order = order
  end

  def create_join
    if !session[:current_user] && params[:input_order][:name].present?
      session[:current_user] = params[:input_order][:name]
    end
    fill_personal_order_details
    if params[:commit] == "Guardar"
      redirect_to join_order_path(@order.slug)
    else
      redirect_to order_path(@order.id)
    end
  end

  def send_order_slug
    redirect_to join_order_path(params[:join_order][:slug])
  end

  def join
    @order = Order.find_by(slug: params[:id])
    if !@order
      redirect_to orders_path
    else
      if !@order.open || @order.was_ordered?
        redirect_to order_path(@order.id)
      end
    end
  end

  def confirm
    @order = Order.find(params[:id])
    if @order.was_ordered?
      flash[:info] = 'El pedido ya fue realizado'
      redirect_to orders_path
    end
  end

  def finish
    @order = Order.find(params[:id])
    @order.update(price: params[:order_data]['price'].to_i)
    redirect_to order_path(@order.id)
  end

  def show
    @order = Order.find_by(id: params[:id])
    if !@order
      redirect_to orders_path
    end
  end

  private

  def fill_personal_order_details
    @order = Order.find(params[:order_id])
    person_name = params[:input_order]['name'].presence || session[:current_user]
    params[:input_order].permit!
    params[:input_order]['q'].to_h.map do |variety_id, quantity|
      variety_name = get_variety_name(@order, variety_id)
      detail = search_detail(person_name, variety_name)
      if detail
        update_detail(detail, person_name, quantity)
      else
        if quantity.to_i != 0
          @order.order_details << OrderDetail.new(person: person_name, order_id: @order.id, quantity: quantity.to_i, variety_name: variety_name)
        end
      end
    end
    @order.save
  end

  def fill_order(order_id)
    @order = Order.find(order_id)
    params[:input_order].permit!
    params[:input_order]['q'].to_h.map do |person_id, varieties_chosen|
      person_name = params[:input_order]['name'][person_id]
      person_name_previous = params[:input_order]['previous_name'][person_id]
      varieties_chosen.map do |variety_id, quantity|
        variety_name = get_variety_name(@order, variety_id)
        detail = search_detail(person_name_previous, variety_name)
        if detail
          update_detail(detail, person_name, quantity)
        else
          if quantity.to_i != 0
            @order.order_details << OrderDetail.new(person: person_name, order_id: @order.id, quantity: quantity.to_i, variety_name: variety_name)
          end
        end
      end
    end
    @order.save
  end

  def search_detail(person, variety_name)
    @order.order_details.find_by(person: person, variety_name: variety_name)
  end

  def update_detail(detail, person, quantity)
    if detail
      if quantity.to_i == 0
        detail.destroy
      else
        detail.update(person: person, quantity: quantity.to_i)
      end
    end
    detail
  end

  def get_variety_name(order, variety_id)
    if order.place_id
      variety = Variety.find_by(id: variety_id)
      variety_name = variety.name
    else
      variety_name = params[:input_order][:variety][variety_id.to_s]
    end
    variety_name
  end

end
