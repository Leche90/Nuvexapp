class CartController < ApplicationController
  layout "frontend"
  before_action :authenticate_frontend_user!, only: [ :index, :add, :update_quantity, :remove ] # restrict access only to cart actions
  before_action :initialize_cart

  def index
    if @cart.empty?
      @cart_items = []
      flash[:notice] = "Your cart is empty."
    else
      # Convert keys to integers
      @cart_items = Product.find(@cart.keys.map(&:to_i)).map do |product|
        { product: product, quantity: @cart[product.id.to_s].to_i } # Ensure quantity is an integer
      end
    end
  end


  def add
    product_id = params[:product_id].to_i
    quantity = params[:quantity].to_i

    if @cart[product_id]
      @cart[product_id] += quantity
    else
      @cart[product_id] = quantity
    end

    save_cart
    redirect_to cart_index_path, notice: "Product added to cart."
  end

  def update_quantity
    product_id = params[:product_id].to_i
    quantity = params[:quantity].to_i

    if quantity <= 0
      @cart.delete(product_id)
    else
      @cart[product_id] = quantity
    end

    save_cart
    redirect_to cart_index_path, notice: "Cart updated."
  end

  def remove
    product_id = params[:product_id].to_i
    @cart.delete(product_id.to_s)

    save_cart
    redirect_to cart_index_path, notice: "Item removed from cart."
  end

  private

  def initialize_cart
    session[:cart] ||= {}
    @cart = session[:cart]
  end

  def save_cart
    session[:cart] = @cart
  end
end
