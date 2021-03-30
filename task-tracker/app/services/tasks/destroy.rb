module Tasks
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

    def call(task:)
      return unless task
      task_public_id = task.public_id
      send_event(task_public_id) if task.destroy
    end

    private

    attr_reader :event_sender, :randomizer, :time, :topics

    def send_event(task_public_id)
      event_sender.call(
        topic: topics.dig(:tasks, :cud, :destroyed),
        data: event_data(task_public_id)
      )
    end

    def event_data(task_public_id)
      {
        event_id: randomizer.uuid,
        event_version: 1,
        event_time: time.now.to_s,
        producer: 'tasks_destory_service',
        event_name: 'TaskDestroyed',
        data: {
          public_id: task_public_id
        }
      }
    end
  end
end
