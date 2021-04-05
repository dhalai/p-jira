module Auditlogs
  module Cud
    class GeneralConsumer < ApplicationConsumer
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
        when [topics.dig(:auditlogs, :events, :created), 1]
          super(msg) do
            Auditlogs::Create.new.call(
              payload: msg.payload['data']
            )
          end
        end
      end
    end
  end
end
