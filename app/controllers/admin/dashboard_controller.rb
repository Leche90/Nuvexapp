class Admin::DashboardController < ApplicationController
  layout "admin"
  before_action :authenticate_admin_user!
  before_action :authorize_admin
  def index
  end

  private

  def authorize_admin
    redirect_to root_path, alert: "Access Denied" unless current_admin_user&.admin?
  end
end
