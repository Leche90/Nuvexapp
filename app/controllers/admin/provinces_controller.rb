class Admin::ProvincesController < ApplicationController
  before_action :authenticate_admin_user!
  layout "admin"
  def index
    @provinces = Province.all
  end

  def edit
    @province = Province.find(params[:id])
  end

  def update
    @province = Province.find(params[:id])
    if @province.update(province_params)
      redirect_to admin_provinces_path, notice: "Tax rates updated successfully."
    else
      flash.now[:alert] = "There was an issue updating the tax rates."
      render :edit
    end
  end

  private

  def province_params
    params.require(:province).permit(:gst, :pst, :hst)
  end
end
