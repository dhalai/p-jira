module Users
  class Update
    USER_COLUMNS = %w[
      public_id full_name role phone_number slack_account
    ].freeze

    def initialize(
      event_sender: Events::Sender.new,
      topics: Topics.new
    )

      @event_sender = event_sender
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

    attr_reader :event_sender, :topics

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
        producer: 'auth_users_update_service',
        event_name: topics.dig(:users, :events, :updated),
        data: user.attributes.slice(*USER_COLUMNS)
      }
    end

    def user_role_updated_event_data(user)
      {
        producer: 'auth_users_update_service',
        event_name: topics.dig(:users, :events, :role_updated),
        data: {
          public_id: user.public_id,
          role: user.role
        }
      }
    end
  end
end
