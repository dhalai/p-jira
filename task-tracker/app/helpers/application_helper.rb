module ApplicationHelper
  def username
    @current_user&.full_name
  end
end
