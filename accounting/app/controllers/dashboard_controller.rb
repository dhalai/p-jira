class DashboardController < ApplicationController
  before_action :authorize
  before_action :check_permissons

  def index
    @users = User.all
  end
end
