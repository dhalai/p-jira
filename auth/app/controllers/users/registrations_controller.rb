module Users
  class RegistrationsController < Devise::RegistrationsController
    USER_COLUMNS = %w[
      public_id full_name role phone_number slack_account
    ].freeze

    protected

    def sign_up(_, user)
      super

      Events::Sender.new.call(
        topic: topics.dig(:users, :cud, :general),
        data: event_data(user.reload)
      )
    end

    def event_data(user)
      {
        producer: 'users_registration_service',
        event_name: topics.dig(:users, :events, :created),
        data: user.attributes.slice(*USER_COLUMNS)
      }
    end

    private

    def topics
      @topics ||= Topics.new.call
    end
  end
end
