class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[index]
  before_action :set_user, only: %i[show edit update destroy]

  def index
    @users = User.all
  end

  def edit
  end

  def update
    if updated_user?
      redirect_to root_path, notice: 'User was updated'
    else
      render :edit
    end
  end

  def destroy
    if destroyed_user?
      redirect_to root_path, notice: 'User was destroyed'
    else
      redirect_to root_path
    end
  end

  def current
    respond_to do |format|
      format.json  { render json: current_user }
    end
  end

  private

  def updated_user?
    Users::Update.new.call(user: @user, params: user_params)
  end

  def destroyed_user?
    Users::Destroy.new.call(user: @user)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def current_user
    return super unless doorkeeper_token
    User.find(doorkeeper_token.resource_owner_id)
  end

  def user_params
    params.require(:user).permit(
      :full_name, :role, :phone_number, :slack_account
    )
  end
end
