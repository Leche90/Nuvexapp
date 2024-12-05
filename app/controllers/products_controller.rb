class ProductsController < ApplicationController
  layout "frontend"

  def index
    # Start with all products
    @products = Product.all

    # Handle keyword search
    if params[:keyword].present?
      @products = @products.where("products.name LIKE ? OR products.description LIKE ?", "%#{params[:keyword]}%", "%#{params[:keyword]}%")
    end

    # Handle category filter via join table
    if params[:category_id].present?
      @products = @products.joins(:categories).where(categories: { id: params[:category_id] })
    end

    # Handle additional filters like "new" and "recently_updated"
    if params[:filter] == "new"
      @products = @products.new_products
    elsif params[:filter] == "recently_updated"
      @products = @products.recently_updated
    end

    # Paginate the results and order by creation date (or any other criteria)
    @products = @products.order(created_at: :desc).page(params[:page]).per(10)

    # Fetch categories for the dropdown menu (to filter products by category)
    @categories = Category.all
  end

  def sho
    @product = Product.find(params[:id])

    # Fetch related products that share at least one category with the current product
    @related_products = Product.joins(:categories)
                               .where(categories: { id: @product.category_ids })
                               .where.not(id: @product.id)  # Exclude the current product
                               .distinct  # Avoid duplicates
                               .limit(4)  # Limit the number of related products displayed
  end
end
