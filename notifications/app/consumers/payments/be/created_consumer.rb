module Payments
  module Be
    class CreatedConsumer < ApplicationConsumer
      def consume
        params_batch.each do |msg|
          super(msg) do
            process_msg(msg)
          end
        end
      end

      private

      def process_msg(msg)
        case [msg.payload['event_name'], msg.payload['event_version']]
        when [topics.dig(:payments, :events, :daily_payment_created), 1]
          super(msg) do
            Notifications::PaymentCreated.new.call(
              payload: msg.payload['data']
            )
          end
        end
      end
    end
  end
end
