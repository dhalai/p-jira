module Users
  class RegistrationsController < Devise::RegistrationsController

    protected

    def sign_up(_, user)
      super

      Events::Sender.new.call(
        topic: Topics.new.call.dig(:users, :cud, :general),
        data: event_data(user.reload)
      )
    end

    def event_data(user)
      {
        event_id: SecureRandom.uuid,
        event_version: 1,
        event_time: Time.now.to_s,
        producer: 'users_registration_service',
        event_name: 'UserCreated',
        data: user.attributes
      }
    end
  end
end
