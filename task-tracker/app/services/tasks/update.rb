module Tasks
  class Update
    def initialize(
      model: Task,
      event_sender: Events::Sender.new,
      randomizer: SecureRandom,
      time: Time,
      topics: Topics.new
    )
      @model = model
      @event_sender = event_sender
      @randomizer = randomizer
      @time = time
      @topics = topics.call
    end

    def call(id:, params:)
      task = model.find_by(id: id)
      return unless task.present?

      if task.update(params)
        send_event(task.reload)
        return task
      end
    end

    private

    attr_reader :model, :event_sender, :randomizer, :time, :topics

    def send_event(task)
      event_sender.call(
        topic: topics.dig(:tasks, :cud, :general),
        data: event_data(task)
      )
    end

    def event_data(task)
      {
        event_id: randomizer.uuid,
        event_version: 1,
        event_time: time.now.to_s,
        producer: 'tasks_update_service',
        event_name: 'TaskUpdated',
        data: task.attributes
      }
    end
  end
end
