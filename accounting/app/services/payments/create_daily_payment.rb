module Payments
  class CreateDailyPayment
    def initialize(
      user_model: User,
      auditlog_creator: Auditlogs::Create,
      event_sender: Events::Sender.new,
      randomizer: SecureRandom,
      time: Time,
      topics: Topics.new
    )
      @user_model = user_model
      @auditlog_creator = auditlog_creator
      @event_sender = event_sender
      @randomizer = randomizer
      @time = time
      @topics = topics.call
    end

    def call(user_id:)
      user = user_model.find_by(id: user_id)
      return unless user
      return if already_paid?(user)

      user_credit = credit(user)

      user_model.transaction do
        user.update(balance: user.balance.to_i + user_credit)
        auditlog_creator.new.call(
          data: auditlog_data(user, user_credit)
        )
        send_event(user, user_credit)
      end
    end

    private

    attr_reader :user_model, :auditlog_creator,
                :event_sender, :randomizer, :time, :topics

    def already_paid?(user)
      user.auditlogs.where(
        task_id: nil,
        created_at: (Date.yesterday.beginning_of_day..Date.yesterday.end_of_day)
      ).exists?
    end

    def credit(user)
      user.auditlogs.where(
        created_at: (Date.yesterday.beginning_of_day..Date.yesterday.end_of_day)
      ).sum(:credit)
    end

    def auditlog_data(user, user_credit)
      {
        user_id: user.id,
        debit: user_credit
      }
    end

    def send_event(user, user_credit)
      event_sender.call(
        topic: topics.dig(:payments, :be, :created),
        data: event_data(user, user_credit)
      )
    end

    def event_data(user, user_credit)
      {
        event_id: randomizer.uuid,
        event_version: 1,
        event_time: time.now.to_s,
        producer: 'accounting_create_daily_payments_service',
        event_name: 'DailyPaymentCreated',
        data: {
          user_id: user.public_id,
          payment: user_credit
        }
      }
    end
  end
end
