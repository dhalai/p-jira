class DailyPaymentWorker
  include Sidekiq::Worker

  def perform(user_id)
    Payments::CreateDailyPayment.new.call(user_id: user_id)
  end
end
