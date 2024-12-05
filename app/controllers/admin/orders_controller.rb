class Admin::OrdersController < ApplicationController
  before_action :authenticate_admin_user!
  layout "admin"
  def index
    @customers = User.includes(orders: [ :order_items, :address ]).all
  end

  def show
  end

  def edit
  end
end
