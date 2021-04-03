module Tasks
  class Update
    def initialize(
      model: Task,
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

    def call(id:, params:)
      task = model.find_by(id: id)
      return unless task.present?

      return unless task.update(params)

      send_task_updated_event(task.reload)

      if task.done? && params[:status] == 'done'
        send_task_finished_event(task.reload)
      end

      task
    end

    private

    attr_reader :model, :event_sender, :randomizer, :time, :topics

    def send_task_updated_event(task)
      event_sender.call(
        topic: topics.dig(:tasks, :cud, :general),
        data: task_updated_event_data(task)
      )
    end

    def task_updated_event_data(task)
      {
        event_id: randomizer.uuid,
        event_version: 1,
        event_time: time.now.to_s,
        producer: 'tasks_update_service',
        event_name: 'TaskUpdated',
        data: task.attributes
      }
    end

    def send_task_finished_event(task)
      event_sender.call(
        topic: topics.dig(:tasks, :be, :finished),
        data: task_finished_event_data(task)
      )
    end

    def task_finished_event_data(task)
      {
        event_id: randomizer.uuid,
        event_version: 1,
        event_time: time.now.to_s,
        producer: 'tasks_update_service',
        event_name: 'TaskFinished',
        data: {
          public_id: task.public_id
        }
      }
    end
  end
end
