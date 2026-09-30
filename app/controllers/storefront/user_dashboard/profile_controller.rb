# app/controllers/storefront/user_dashboard/profile_controller.rb
class Storefront::UserDashboard::ProfileController < ApplicationController # Or ApplicationController
  before_action :authenticate_user!

  def show
    @user = current_user
  end

  def edit
    @user = current_user
  end

  def update
    @user = current_user
    if @user.update(profile_params)
      redirect_to user_dashboard_path, notice: 'Profile updated successfully.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def profile_params
    # Permit only safe attributes for profile update
    params.require(:user).permit(:first_name, :last_name, :email, :phone_number, :date_of_birth)
    # Do NOT permit :password, :reset_password_token, :admin, :role, etc. unless specifically handled
  end
end