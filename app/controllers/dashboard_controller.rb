class DashboardController < ApplicationController 

    layout 'admin'

    before_action :authenticate_user!
    before_action :authorize_admin!

   
def authorize_admin!
    unless current_user&.admin?
      redirect_to root_path, alert: "You are not authorized to access this section."
    end
  end
end