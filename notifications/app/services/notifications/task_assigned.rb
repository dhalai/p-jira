module Notifications
  class TaskAssigned
    def initialize(logger: Rails.logger, model: User)
      @logger = logger
      @model = model
    end

    def call(payload:)
      user = model.find_by(public_id: payload['assignee_id'])
      #TODO: add the backoff logic
      return unless user

      logger.info("Send email about the task. Email: #{user.email}")
      logger.info("Send sms about the task. Phone number: #{user.phone_number}")
      logger.info("Send slack notification about the task. Slack account: #{user.slack_account}")
    end

    private

    attr_reader :logger, :model
  end
end
