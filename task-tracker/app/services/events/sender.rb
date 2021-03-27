module Events
  class Sender
    def initialize(
      logger: Rails.logger,
      producer_wrapper: WaterDrop::SyncProducer,
      producer: DeliveryBoy
    )
      @logger = logger
      @producer_wrapper = producer_wrapper
      @producer = producer
    end

    def call(topic:, data:)
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

    private

    attr_reader :logger, :producer, :producer_wrapper
  end
end
