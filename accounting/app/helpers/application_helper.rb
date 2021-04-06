module ApplicationHelper
  def username
    @current_user&.full_name
  end

  def daily_earned_amount
    Auditlogs::CalculateDailyEarnedAmount.new.call
  end
end
