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
end