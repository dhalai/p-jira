module TasksHelper
  def user_task?(task)
    @current_user&.tasks&.include?(task)
  end
end
