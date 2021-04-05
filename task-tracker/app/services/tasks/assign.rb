module Tasks
  class Assign
    def initialize(
      user_model: User,
      event_sender: Events::Sender.new,
      topics: Topics.new
    )
      @user_model = user_model
      @event_sender = event_sender
      @topics = topics.call
    end

    def call(task:)
      if task.update(user_id: random_user_id)
        send_business_event(task)
        send_cud_event(task)
      end
    end

    private

    attr_reader :user_model, :event_sender, :topics

    def random_user_id
      user_model.pluck(:id).sample
    end

    def send_business_event(task)
      event_sender.call(
        topic: topics.dig(:tasks, :be, :assigned),
        data: event_data(task)
      )
    end

    def event_data(task)
      {
        producer: 'tasks-tracker_assign_service',
        event_name: topics.dig(:tasks, :events, :assigned),
        data: {
          public_id: task.public_id,
          assignee_id: task.user.public_id
        }
      }
    end

    def send_cud_event(task)
      event_sender.call(
        topic: topics.dig(:tasks, :cud, :assigned),
        data: event_data(task)
      )
    end
  end
end
