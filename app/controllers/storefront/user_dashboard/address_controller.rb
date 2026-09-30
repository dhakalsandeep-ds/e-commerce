# app/controllers/storefront/user_dashboard/address_controller.rb
class Storefront::UserDashboard::AddressController < ApplicationController # Or ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(address_params)
      redirect_to user_dashboard_path, notice: 'Address updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def address_params
    # Permit address-related attributes
    params.require(:user).permit(:address_line1, :address_line2, :city, :state, :postal_code, :country)
  end
end