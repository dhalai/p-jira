class TaskDecorator < SimpleDelegator
  def username
    user&.full_name
  end
end
