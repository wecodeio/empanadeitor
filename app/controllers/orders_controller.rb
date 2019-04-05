class OrdersController < ApplicationController
  def index
    @places = Place.all
  end

  def new
    @place = Place.find(params[:place_id])
    @order = Order.create(place: @place)
    @order.set_place = @place
    @order.save
    session[:orders_created] = session[:orders_created].presence || []
    session[:orders_created] << @order.slug
    redirect_to order_path(@order.slug)
  end

  def new_custom_place
    @order = Order.create
    @order.place_name = params[:custom_place][:name]
    @order.save
    session[:orders_created] = session[:orders_created].presence || []
    session[:orders_created] << @order.slug
    redirect_to order_path(@order.slug)
  end

  def create
    fill_order(params[:input_order][:slug])
    if params[:commit] == "Pedir"
      @order.update(open: false)
    end
    redirect_to order_path(@order.slug)
  end

  def edit(order)
    if order.place_id
      edit_existing_place(order)
    else
      edit_custom_place(order)
    end

  end

  def edit_existing_place(order)
    render 'edit'
    @order = order
  end

  def edit_custom_place(order)
    render 'edit_custom_place'
    @order = order
  end

  def create_join
    if !session[:current_user] && params[:input_order][:name].present?
      session[:current_user] = params[:input_order][:name]
    end
    fill_personal_order_details(params[:input_order][:slug])
    if params[:commit] == "Guardar"
      redirect_to order_path(@order.slug)
    end
  end

  def send_order_slug
    redirect_to order_path(params[:join_order][:slug])
  end

  def join(order)
    render 'join'
    @order = order
  end

  def confirm(order)
    render 'confirm'
  end

  def finish
    @order = Order.find_by(slug: params[:id])
    if params[:commit] == "Finalizar"
      @order.update(price: params[:order_data]['price'].to_i)
    else
      reopen(@order)
    end
    redirect_to order_path(@order.slug)
  end

  def view_summary
    render 'finish'
  end

  def reopen(order)
    order.update(open: true)
  end

  def show
    session[:orders_created] = session[:orders_created].presence || []
    @order = Order.find_by(slug: params[:id])
    if !@order
      redirect_to orders_path
      #mensaje flash
    else
      if @order.open && session[:orders_created].include?(params[:id])
        edit(@order)
      elsif !@order.open && !@order.was_ordered? && session[:orders_created].include?(params[:id])
        confirm(@order)
      elsif @order.was_ordered?
        view_summary
      elsif @order.open && !session[:orders_created].include?(params[:id])
        join(@order)
      end
    end

  end

  private

  def fill_personal_order_details(slug)
    @order = Order.find_by(slug: slug)
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

  def fill_order(slug)
    @order = Order.find_by(slug: slug)
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
