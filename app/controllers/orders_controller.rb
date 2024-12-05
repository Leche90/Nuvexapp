class OrdersController < ApplicationController
  layout "frontend"
  before_action :authenticate_frontend_user!, only: [ :new, :create, :show ]
  before_action :set_order, only: [ :show ]
  def new
  end

  def index
    # Fetch all orders for the current user
    @orders = current_frontend_user.orders.includes(:order_items, :address).order(created_at: :desc)
  end

  def create
  end

  def show
    @order = current_frontend_user.orders.includes(:order_items, :address).find(params[:id])
    Rails.logger.debug "Order after address association: #{@order.attributes}"
     Rails.logger.debug "Order details: #{@order.inspect}"
  Rails.logger.debug "Order address: #{@order.address.inspect}"
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end
end
