class EventSender
  def initialize(logger: Rails.logger)
    @logger = logger
  end

  def call(topic:, data:)
    logger.info("Produce event - topic: #{topic} data: #{data}")
  end

  private

  attr_reader :logger
end
