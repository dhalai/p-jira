module Tasks
  class Create
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

    def call(params:)
      task = build_task(params)
      return unless task.valid?

      if task.save
        send_event(task)
        task
      end
    end

    private

    attr_reader :model, :event_sender, :randomizer, :time, :topics

    def build_task(params)
      model.new(
        params.merge(
          public_id: randomizer.uuid
        )
      )
    end

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
        producer: 'tasks_create_service',
        event_name: 'TaskCreated',
        data: task.attributes
      }
    end
  end
end
