module Tasks
  class Create
    TASK_COLUMNS = %w[title public_id status description].freeze

    def initialize(
      model: Task,
      event_sender: Events::Sender.new,
      topics: Topics.new,
      randomizer: SecureRandom
    )
      @model = model
      @event_sender = event_sender
      @topics = topics.call
      @randomizer = randomizer
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

    attr_reader :model, :event_sender, :topics, :randomizer

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
        producer: 'tasks-tracker_create_service',
        event_name: topics.dig(:tasks, :events, :created),
        data: task.attributes.slice(*TASK_COLUMNS)
      }
    end
  end
end
