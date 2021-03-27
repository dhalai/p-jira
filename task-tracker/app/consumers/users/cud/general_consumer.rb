module Users
  module Cud
    class GeneralConsumer < Karafka::BaseConsumer
      def consume
        params_batch.each do |msg|
          p '*' * 50
          p msg.payload
          p '*' * 50
        end
      end
    end
  end
end
