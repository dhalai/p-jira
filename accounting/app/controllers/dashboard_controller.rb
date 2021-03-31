class DashboardController < ApplicationController
  before_action :authorize
  before_action :check_permissons

  def index
  end

  private

  def check_permissons
    return if @current_user.admin? || @current_user.accountant?
    render plain: 'Unauthorized', status: :unauthorized, layout: false
  end
end
