class TaskDecorator < SimpleDelegator
  def user_name
    user&.name
  end
end
