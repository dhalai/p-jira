module Tasks
  class Create
    def initialize(
      model: ::Task,
      task_price_calculator: Tasks::CalculatePrice,
      event_sender: Events::Sender.new,
      randomizer: SecureRandom,
      time: Time,
      topics: Topics.new
    )
      @model = model
      @task_price_calculator = task_price_calculator
      @event_sender = event_sender
      @randomizer = randomizer
      @time = time
      @topics = topics.call
    end

    def call(payload:)
      task_price = task_price_calculator.new.call

      task = model.create(
        payload.merge(price: task_price)
      )
      return task unless task.valid?

      send_price_calculated_event(task)
      task
    end

    private

    attr_reader :model, :task_price_calculator,
                :event_sender, :randomizer, :time, :topics

    def send_price_calculated_event(task)
      event_sender.call(
        topic: topics.dig(:tasks, :cud, :price_calculated),
        data: event_data(task)
      )
    end

    def event_data(task)
      {
        event_id: randomizer.uuid,
        event_version: 1,
        event_time: time.now.to_s,
        producer: 'tasks_update_or_create_service',
        event_name: 'TaskPriceCalculated',
        data: {
          public_id: task.public_id,
          price: task.price
        }
      }
    end
  end
end
