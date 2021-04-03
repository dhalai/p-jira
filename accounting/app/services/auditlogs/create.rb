module Auditlogs
  class Create
    def initialize(
      model: ::Auditlog,
      event_sender: Events::Sender.new,
      randomizer: SecureRandom,
      time: Time,
      topics: Topics.new
    )
      @model = model
      @event_sender = event_sender
      @randomizer = randomizer
      @time = time
      @topics = topics.call
    end

    def call(data:)
      log_record = model.create(
        data.merge(public_id: randomizer.uuid)
      )
      send_event(log_record)
      log_record
    end

    private

    attr_reader :model, :event_sender, :randomizer, :time, :topics

    def send_event(log_record)
      event_sender.call(
        topic: topics.dig(:auditlogs, :cud, :general),
        data: event_data(log_record)
      )
    end

    def event_data(log_record)
      {
        event_id: randomizer.uuid,
        event_version: 1,
        event_time: time.now.to_s,
        producer: 'auditlogs_create_service',
        event_name: 'AuditlogCreated',
        data: {
          public_id: log_record.public_id,
          debit: log_record.debit,
          credit: log_record.credit
        }
      }
    end
  end
end
