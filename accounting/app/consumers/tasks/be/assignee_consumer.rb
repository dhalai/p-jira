module Tasks
  module Be
    class AssigneeConsumer < ApplicationConsumer
      def consume
        # TODO: move to sidekiq
        params_batch.each do |msg|
          super(msg) do
            process_msg(msg)
          end
        end
      end

      private

      def process_msg(msg)
        case [msg.payload['event_name'], msg.payload['event_version']]
        when [topics.dig(:tasks, :events, :assigned), 1]
          super(msg) do
            Tasks::Assign.new.call(
              payload: msg.payload['data']
            )
          end
        end
      end
    end
  end
end
