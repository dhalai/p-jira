class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[index]
  before_action :set_user, only: %i[show edit update destroy]

  def index
    @users = User.all
  end

  def edit
  end

  def update
    send_event(topic: 'users-stream', data: user_updated_event_data)
    send_event(topic: :users, data: user_role_updated_event_data) if new_user_role?

    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to root_path, notice: 'User was updated' }
        format.json { render :index, status: :ok, location: @user }
      else
        format.html { render :edit }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @user.update(active: false, disabled_at: Time.now)

    respond_to do |format|
      format.html { redirect_to root_path, notice: 'User was destroyed' }
      format.json { head :no_content }
    end
  end

  def current
    respond_to do |format|
      format.json  { render json: current_user }
    end
  end

  private

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

  def new_user_role?
    @user.role != user_params[:role]
  end

  def send_event(topic:, data:)
    EventSender.new.call(
      topic: topic,
      data: data
    )
  end

  def user_updated_event_data
    {
      event_name: 'UserUpdated',
      data: {
        public_id: @user.public_id,
        full_name: @user.full_name,
        role: @user.role,
        phone_number: @user.phone_number,
        slack_account: @user.slack_account
      }
    }
  end

  def user_role_updated_event_data
    {
      event_name: 'UserRoleUpdated',
      data: {
        public_id: @user.public_id,
        role: @user.role
      }
    }
  end
end
