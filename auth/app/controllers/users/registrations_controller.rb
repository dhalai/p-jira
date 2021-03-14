module Users
  class RegistrationsController < Devise::RegistrationsController

    protected

    def sign_up(_, user)
      super

      send_event(
        topic: 'users-stream',
        data: user_created_event_data(resource.reload)
      )
    end

    def send_event(topic:, data:)
      EventSender.new.call(
        topic: topic,
        data: data
      )
    end

    def user_created_event_data(user)
      {
        event_name: 'UserCreated',
        data: {
          public_id: user.public_id,
          email: user.email
        }
      }
    end
  end
end
