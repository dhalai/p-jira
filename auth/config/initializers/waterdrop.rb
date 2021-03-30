require 'water_drop'
require 'water_drop/sync_producer'

WaterDrop.setup do |config|
  config.deliver = true
  config.kafka.seed_brokers = [ENV['KAFKA_SEED_BROKER']]
end
