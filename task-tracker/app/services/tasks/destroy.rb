module Tasks
  class Destroy
    def initialize(
      event_sender: Events::Sender.new,
      topics: Topics.new
    )
      @event_sender = event_sender
      @topics = topics.call
    end

    def call(task:)
      return unless task
      task_public_id = task.public_id
      send_event(task_public_id) if task.destroy
    end

    private

    attr_reader :event_sender, :topics

    def send_event(task_public_id)
      event_sender.call(
        topic: topics.dig(:tasks, :cud, :destroyed),
        data: event_data(task_public_id)
      )
    end

    def event_data(task_public_id)
      {
        producer: 'task-tracker_destory_service',
        event_name: topics.dig(:tasks, :events, :destroyed),
        data: {
          public_id: task_public_id
        }
      }
    end
  end
end
