class TasksController < ApplicationController
  before_action :authorize
  before_action :check_permissons, only: %i[edit update destroy]

  def index
    @tasks = task_scope.map do |task|
      TaskDecorator.new(task)
    end
  end

  def new
    @data = task_data
  end

  def create
    if new_task
      redirect_to root_path, notice: t('.created')
    else
      @data = task_data(task: new_task)
      render :new
    end
  end

  def edit
    @data = task_data(task: load_task)
  end

  def update
    if updated_task
      redirect_to root_path, notice: t('.updated')
    else
      @data = task_data(task: updated_task)
      render :edit
    end
  end

  def destroy
    Tasks::Destroy.new.call(task: load_task)
    redirect_to root_path, notice: t('.destroyed')
  end

  def assign
    return redirect_to root_path if !@current_user.admin? && !@current_user.manager?

    task_class.opened.each do |task|
      Tasks::Assign.new.call(task: task)
    end

    redirect_to root_path, notice: t('.assigned')
  end

  private

  def check_permissons
    return if @current_user.admin? || @current_user.manager?
    return if @current_user&.tasks&.include?(load_task)
    redirect_to root_path
  end

  def load_task
    task_class.find_by(id: params[:id])
  end

  def task_data(task: task_class.new)
    {
      task: task,
      statuses: task_class.statuses.keys - ['deleted'],
      users: User.all
    }
  end

  def new_task
    @new_task ||= Tasks::Create.new.call(params: permitted_params)
  end

  def updated_task
    @updated_task ||= Tasks::Update.new.call(
      id: params[:id],
      params: permitted_params
    )
  end

  def permitted_params
    params.require(:task).permit(
      :id, :title, :description, :status, :user_id
    )
  end

  def task_scope
    if @current_user.admin? || @current_user.manager?
      task_class.includes(:user).all
    elsif @current_user.employee?
      @current_user.tasks
    else
      []
    end
  end

  def task_class
    Task
  end
end
