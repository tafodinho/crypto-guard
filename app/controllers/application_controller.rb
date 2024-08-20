class ApplicationController < ActionController::Base

  protected

  # Override Devise's after sign out path
  def after_sign_out_path_for(resource_or_scope)
    new_user_session_path # or any other path you want to redirect to
  end
end
