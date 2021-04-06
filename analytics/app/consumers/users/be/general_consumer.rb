module Users
  module Be
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
        when [topics.dig(:users, :events, :role_updated), 1]
          super(msg) do
            Users::UpdateOrCreate.new.call(
              payload: msg.payload['data']
            )
          end
        end
      end
    end
  end
end
