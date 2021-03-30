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
        # byebug
      end
    end
  end
end
