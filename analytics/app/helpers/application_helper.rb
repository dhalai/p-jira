module ApplicationHelper
  def username
    @current_user&.full_name
  end

  def daily_most_expensive_task
    @daily_most_expensive_task ||= Auditlogs::CalculateMostExpensiveTask.new.call(
      date_range: (Date.today.beginning_of_day..Date.today.end_of_day)
    )
  end

  def weekly_most_expensive_task
    @weakly_most_expensive_task ||= Auditlogs::CalculateMostExpensiveTask.new.call(
      date_range: (Date.today.beginning_of_week..Date.today.end_of_day)
    )
  end

  def monthly_most_expensive_task
    @monthly_most_expensive_task ||= Auditlogs::CalculateMostExpensiveTask.new.call(
      date_range: (Date.today.beginning_of_month..Date.today.end_of_day)
    )
  end

  def current_date
    Date.today
  end

  def current_week
    "#{Date.today.beginning_of_week} - #{Date.today.end_of_week}"
  end

  def current_month
    "#{Date.today.beginning_of_month} - #{Date.today.end_of_month}"
  end
end
