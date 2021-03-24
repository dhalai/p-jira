module Tasks
  class Assign
    def initialize(
      user_model: User,
      event_sender: Events::Sender.new,
      randomizer: SecureRandom,
      time: Time,
      topics: Topics.new
    )
      @user_model = user_model
      @event_sender = event_sender
      @randomizer = randomizer
      @time = time
      @topics = topics.call
    end

    def call(task:)
      if task.update(user_id: random_user_id)
        event_sender.call(
          topic: topic_name,
          data: event_data(task)
        )
      end
    end

    private

    attr_reader :user_model, :event_sender, :randomizer, :time, :topics

    def random_user_id
      user_model.pluck(:id).sample
    end

    def topic_name
      topics.dig(:tasks, :assigned)
    end

    def event_data(task)
      {
        event_id: randomizer.uuid,
        event_version: 1,
        event_time: time.now.to_s,
        producer: 'tasks_assign_service',
        event_name: 'TaskAssigned',
        data: {
          public_id: task.public_id,
          assignee_id: task.reload.user.public_id
        }
      }
    end
  end
end
