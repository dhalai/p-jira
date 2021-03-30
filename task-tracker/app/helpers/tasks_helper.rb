module TasksHelper
  def user_task?(task)
    @current_user&.tasks&.include?(task)
  end

  def can_assign?(user)
    user.admin? ||
      user.manager?
  end

  def can_modify?(user)
    user.admin? ||
      user.manager?
  end
end
