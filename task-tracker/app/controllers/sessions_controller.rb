class SessionsController < ApplicationController
  def index
    render :index, layout: false
  end

  def create
    if identity = find_or_create_user
      session[:user] = identity.user
      return redirect_to root_path
    end

    redirect_to login_path
  end

  def destroy
    session[:user] = nil
    redirect_to login_path
  end

  private

  def find_or_create_user
    Users::Create.new.call(payload: request.env['omniauth.auth'])
  end
end
