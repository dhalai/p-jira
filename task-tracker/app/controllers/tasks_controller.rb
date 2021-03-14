class TasksController < ApplicationController
  def index
    @tasks = task_class.all.includes(:user).map do |task|
      TaskDecorator.new(task)
    end
  end

  def new
    @data = task_data
  end

  def create
    if new_task.valid?
      new_task.save
      redirect_to action: 'index'
    else
      @data = task_data(task: new_task)
      render :new
    end
  end

  def edit
    @data = task_data(
      task: task_class.find_by(id: params[:id])
    )
  end

  def update
    if updated_task
      redirect_to action: 'index'
    else
      @data = task_data(task: updated_task)
      render :edit
    end
  end

  def destroy
    @task = task_class.find_by(id: params[:id])
    @task.destroy

    redirect_to action: 'index'
  end

  private

  def task_data(task: task_class.new)
    {
      task: task,
      statuses: task_class.statuses.keys,
      users: User.all
    }
  end

  def new_task
    @new_task ||= task_class.new(permitted_params)
  end

  def updated_task
    @updated_task ||= task_class.find_by(id: params[:id]).update(
      permitted_params
    )
  end

  def permitted_params
    params.require(:task).permit(
      :id, :title, :description, :status, :user_id
    )
  end

  def task_class
    Task
  end
end
