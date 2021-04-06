# frozen_string_literal: true

# Application consumer from which all Karafka consumers should inherit
# You can rename it if it would conflict with your current code base (in case you're integrating
# Karafka with other frameworks)
class ApplicationConsumer < Karafka::BaseConsumer
  def consume(msg)
    p '*' * 50
    p msg.payload
    p '*' * 50

    yield
  end

  def process_msg(msg)
    validator = validate_schema(msg) rescue nil
    return unless validator
    return yield if validator.success?

    Rails.logger.error("Invalid event: #{validator.failure}, #{msg.payload}")
  end

  def topics
    @topics ||= Topics.new.call
  end

  private

  def validate_schema(msg)
    SchemaRegistry.validate_event(
      msg.payload,
      msg.payload['event_name'].underscore,
      version: msg.payload['event_version']
    )
  end
end
