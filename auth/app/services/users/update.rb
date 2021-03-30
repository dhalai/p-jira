module Users
  class Update
    def initialize(
      event_sender: Events::Sender.new,
      randomizer: SecureRandom,
      time: Time,
      topics: Topics.new
    )

      @event_sender = event_sender
      @randomizer = randomizer
      @time = time
      @topics = topics.call
    end

    def call(user:, params:)
      if user.update(params)
        send_cud_event(user)
        send_be_event(user) if user.previous_changes[:role].present?
        user
      end
    end

    private

    attr_reader :event_sender, :randomizer, :time, :topics

    def send_cud_event(user)
      event_sender.call(
        topic: topics.dig(:users, :cud, :general),
        data: user_updated_event_data(user)
      )
    end

    def send_be_event(user)
      event_sender.call(
        topic: topics.dig(:users, :be, :general),
        data: user_role_updated_event_data(user)
      )
    end

    def user_updated_event_data(user)
      {
        event_id: randomizer.uuid,
        event_version: 1,
        event_time: time.now.to_s,
        producer: 'users_update_service',
        event_name: 'UserUpdated',
        data: {
          public_id: user.public_id,
          full_name: user.full_name,
          role: user.role,
          phone_number: user.phone_number,
          slack_account: user.slack_account
        }
      }
    end

    def user_role_updated_event_data(user)
      {
        event_id: randomizer.uuid,
        event_version: 1,
        event_time: time.now.to_s,
        producer: 'users_update_service',
        event_name: 'UserRoleUpdated',
        data: {
          public_id: user.public_id,
          role: user.role
        }
      }
    end
  end
end
