module Notifications
  class PaymentCreated
    def initialize(logger: Rails.logger, model: User)
      @logger = logger
      @model = model
    end

    def call(payload:)
      user = model.find_by(public_id: payload['user_id'])
      #TODO: add the backoff logic
      return unless user

      logger.info("Send email about the payment. Email: #{user.email}, payment: #{payload['payment']}")
    end

    private

    attr_reader :logger, :model
  end
end
