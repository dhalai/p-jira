module Users
  class Destroy
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

    def call(user:)
      if user.update(active: false, disabled_at: time.now)
        send_event(user)
        user
      end
    end

    private

    attr_reader :event_sender, :randomizer, :time, :topics

    def send_event(user)
      event_sender.call(
        topic: topics.dig(:users, :be, :general),
        data: event_data(user)
      )
    end

    def event_data(user)
      {
        event_id: randomizer.uuid,
        event_version: 1,
        event_time: time.now.to_s,
        producer: 'users_desroy_service',
        event_name: 'UserDestroyed',
        data: {
          public_id: user.public_id,
        }
      }
    end
  end
end
