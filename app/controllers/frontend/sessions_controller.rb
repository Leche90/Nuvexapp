# app/controllers/frontend/sessions_controller.rb
class Frontend::SessionsController < Devise::SessionsController
  def new
    super
  end

  def destroy
    sign_out :frontend_user
    redirect_to new_frontend_user_session_path
  end

  def after_sign_out_path_for(resource_or_scope)
    new_frontend_user_session_path # Redirect to frontend login page after sign out
  end
end
