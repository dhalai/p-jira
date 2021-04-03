module Payments
  class CreateDailyPayments
    def initialize(model: User)
      @model = model
    end

    def call
      model.find_each do |user|
        DailyPaymentWorker.perform_async(user.id)
      end
    end

    private

    attr_reader :model
  end
end
