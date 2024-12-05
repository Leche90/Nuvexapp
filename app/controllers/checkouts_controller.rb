# CheckoutsController
class CheckoutsController < ApplicationController
  before_action :authenticate_frontend_user!
  before_action :set_user
  before_action :set_cart_items, only: [ :index, :create ]
  before_action :set_provinces, only: [ :index ]
  layout "frontend"

  def index
    Rails.logger.debug "User ID: #{@user.id}"

    if @user.address
      Rails.logger.debug "User's Address: #{@user.address.attributes}"
    else
      Rails.logger.debug "User has no address."
    end

    @order = @user.orders.build
    associate_or_build_address(@order)
    calculate_totals

    Rails.logger.debug "Order after address association: #{@order.attributes}"
  end

  def create
    # Check if cart is empty
    if @cart_items.empty?
      redirect_to cart_index_path, alert: "Your cart is empty."
      return
    end

    # Ensure address or province is provided
    unless @user.address || address_params[:province_id].present?
      flash.now[:alert] = "Please provide your address or at least your province."
      render :index
      return
    end

    # Calculate totals
    calculate_totals

    # Manually assign totals and address to the order
    @order = @user.orders.build(total_price: @total_price, total_tax: @total_tax,
    gst: @gst, pst: @pst, hst: @hst, total_amount: @subtotal)

    associate_or_build_address(@order)
    build_order_items(@order)

    Rails.logger.debug "Order before saving: #{@order.attributes}"

    # Save the order
    if @order.save
      session[:cart] = {}  # Empty the cart after order completion
      redirect_to order_path(@order), notice: "Checkout complete! Your order has been placed."
    else
      Rails.logger.debug "Order errors: #{@order.errors.full_messages.join(', ')}"
      flash[:alert] = "There was an issue processing your order."
      render :index
    end
  end

  private

  # Set the current user
  def set_user
    @user = current_frontend_user
  end

  # Set cart items from session
  def set_cart_items
    @cart = session[:cart] || {}
    @cart_items = Product.find(@cart.keys.map(&:to_i)).map do |product|
      { product: product, quantity: @cart[product.id.to_s].to_i }
    end
  end

  # Set provinces
  def set_provinces
    @provinces = Province.all
  end

  # Calculate totals (subtotal, taxes, total price)
  def calculate_totals
    @subtotal = @cart_items.sum { |item| item[:product].price * item[:quantity] }
    @province = @user.address&.province || Province.find_by(id: address_params[:province_id])

    if @province
      @gst = @subtotal * @province.gst
      @pst = @subtotal * @province.pst
      @hst = @subtotal * @province.hst
    else
      @gst = @pst = @hst = 0
    end

    @total_tax = @gst + @pst + @hst
    @total_price = @subtotal + @total_tax
  end

  # Strong params for address
  def address_params
    params.fetch(:address, {}).permit(:address_line1, :address_line2, :city, :province_id, :postal_code, :country)
  end

  # Associate or build the address for the order
  def associate_or_build_address(order)
    if @user.address
      # Associate with existing address
      order.address = @user.address
      order.address_id = @user.address.id
      Rails.logger.debug "Order associated with existing address: #{order.address.attributes}"
    else
      # Build a new address if none exists and validate
      # new_address = order.build_address(address_params)
      # if new_address.valid?
      #   new_address.save # Save to assign id
      #   order.address_id = new_address.id
      # else
      #   Rails.logger.debug "Address validation failed: #{new_address.errors.full_messages.join(', ')}"
      # end
      # Rails.logger.debug "Order has new address: #{order.address.attributes}"
    end
  end

  # Build the order items based on the cart
  def build_order_items(order)
    @cart_items.each do |item|
      order.order_items.build(
        product: item[:product],
        quantity: item[:quantity],
        price: item[:product].price
      )
    end
  end
end
