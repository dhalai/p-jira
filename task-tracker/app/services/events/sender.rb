module Events
  class Sender
    def initialize(
      logger: Rails.logger,
      producer_wrapper: WaterDrop::SyncProducer,
      producer: DeliveryBoy,
      schema_registry: SchemaRegistry,
      randomizer: SecureRandom,
      time: Time
    )
      @logger = logger
      @producer_wrapper = producer_wrapper
      @producer = producer
      @schema_registry = schema_registry
      @randomizer = randomizer
      @time = time
    end

    def call(topic:, data:)
      data = default_data.merge(data)

      validator = schema_registry.validate_event(
        data,
        data[:event_name].underscore,
        version: data[:event_version]
      )

      if validator.success?
        send_event(topic, data)
      else
        logger.error("Invalid event: #{validator.failure}, #{data}")
      end
    end

    private

    attr_reader :logger, :producer, :producer_wrapper,
                :schema_registry, :randomizer, :time

    def default_data
      {
        event_id: randomizer.uuid,
        event_version: 1,
        event_time: time.now.to_s
      }
    end

    def send_event(topic, data)
      logger.info("Produce event - topic: #{topic} data: #{data}")

      # It is unclear why but it returns
      # *** ArgumentError Exception: wrong number of arguments (given 2, expected 1; required keyword: topic)
      # error
      #
      # producer_wrapper.call(data.to_json, topic: topic)
      #
      # Have to call the DeliveryBoy directly
      producer.deliver(data.to_json, topic: topic)
    end
  end
end
