class AddressesController < ApplicationController
  layout "frontend"
  before_action :set_user
  before_action :set_provinces
  before_action :set_address, only: [ :edit, :update ]

  def new
    @address = @user.build_address # Initializes a new address for the user
    # @provinces = Province.all
  end

  def create
    @address = @user.build_address(address_params)
    @user.update(province_id: @address.province_id) # Ensure the province is assigned to the user

    if @address.save
      redirect_to products_path, notice: "Address successfully created."
    else
      @provinces = Province.all  # Re-fetch provinces in case of form errors
      render :new
    end
  end

  def edit
    @address = @user.address || @user.build_address
  end

  def update
    @user.update(province_id: address_params[:province_id])

    if @address.update(address_params)
      redirect_to user_address_path(@user, @address), notice: "Address successfully updated."
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find(params[:user_id])  # Ensure this is set based on the URL
  end

  def set_provinces
    @provinces = Province.all
  end

  def set_address
    @address = @user.address || Address.find_by(id: params[:id]) # Use find_by to avoid errors if address not found
  end

  def address_params
    params.require(:address).permit(:address_line1, :address_line2, :city, :province_id, :postal_code, :country)
  end
end
