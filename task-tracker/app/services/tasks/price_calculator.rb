module Tasks
  class PriceCalculator
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
      event_sender.call(
        topic: topics.dig(:tasks, :cud, :price_calculated),
        data: event_data(task)
      )
    end

    private

    attr_reader :event_sender, :randomizer, :time, :topics

    def event_data(task)
      {
        event_id: randomizer.uuid,
        event_version: 1,
        event_time: time.now.to_s,
        producer: 'tasks_price_calculator',
        event_name: 'TaskPriceCalculated',
        data: {
          public_id: task.public_id,
          price: calculate_task_price
        }
      }
    end

    def calculate_task_price
      rand(-20..-10)
    end
  end
end
