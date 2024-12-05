# app/controllers/admin/sessions_controller.rb
class Admin::SessionsController < Devise::SessionsController
  before_action :authenticate_admin_user!

  def new
    super
  end

  def create
    super
  end

  def destroy
    sign_out :admin_user
    redirect_to new_admin_user_session_path
  end

  private

  def after_sign_out_path_for(resource_or_scope)
    new_admin_user_session_path # Redirect to admin login page after sign out
  end
end
