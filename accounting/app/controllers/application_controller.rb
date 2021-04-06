class ApplicationController < ActionController::Base
  def authorize
    return redirect_to login_path unless session[:user].present?
    @current_user ||= User.find_by(id: session.dig(:user, 'id')) 

    redirect_to login_path unless @current_user.present?
  end

  def check_permissons
    return if @current_user.admin? || @current_user.accountant?
    render plain: 'Unauthorized', status: :unauthorized, layout: false
  end
end
