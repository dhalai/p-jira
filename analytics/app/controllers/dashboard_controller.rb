class DashboardController < ApplicationController
  before_action :authorize
  before_action :check_permissons

  def index
  end
end
