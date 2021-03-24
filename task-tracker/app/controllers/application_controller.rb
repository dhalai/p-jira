class ApplicationController < ActionController::Base
  def authorize
    redirect_to login_path unless session[:user].present?
    @current_user ||= User.includes(:tasks).find_by(id: session.dig(:user, 'id')) 
  end
end
