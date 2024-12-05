class Admin::ProductsController < ApplicationController
  before_action :authenticate_admin_user!
  before_action :set_product, only: %i[edit update destroy]
  layout "admin"

  def index
    @products = Product.order(created_at: :desc).page(params[:page]).per(10)
  end

  def new
    @product = Product.new
  end

  def create
    @product = Product.new(product_params)
    # Rails.logger.debug "Product params: #{product_params}"
    if @product.save
      redirect_to admin_products_path, notice: "Product was successfully created."
    else
      # Rails.logger.debug "Product errors: #{@product.errors.full_messages}"
      render :new
    end
  end

  def edit
  end

  def update
    Rails.logger.debug "Product params: #{product_params}"

    if @product.update(product_params)
      Rails.logger.debug "Product was successfully updated: #{@product.inspect}"
      redirect_to admin_products_path, notice: "Product was successfully updated."
    else
      Rails.logger.debug "Product update failed: #{@product.errors.full_messages}"
      render :edit
    end
  end


  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to admin_products_path, alert: "Product was successfully deleted."
  end

  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :price, :stock_quantity, :image, category_ids: [])
          .tap do |whitelisted|
            # Remove any blank category_ids
            whitelisted[:category_ids].reject!(&:blank?)

            # Optionally, ensure only valid category IDs are included
            whitelisted[:category_ids].select! { |id| Category.exists?(id) }
          end
  end
end
