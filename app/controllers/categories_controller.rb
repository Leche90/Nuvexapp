class CategoriesController < ApplicationController
  layout "frontend"
  def index
    @categories = Category.all
  end

  def show
    @category = Category.find(params[:id])
    @products = @category.products.order(created_at: :desc).page(params[:page]).per(10)
  end
end
