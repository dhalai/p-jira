module Tasks
  class Update
    TASK_COLUMNS = %w[public_id title description].freeze

    def initialize(
      model: Task,
      event_sender: Events::Sender.new,
      topics: Topics.new
    )
      @model = model
      @event_sender = event_sender
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

    attr_reader :model, :event_sender, :topics

    def send_task_updated_event(task)
      event_sender.call(
        topic: topics.dig(:tasks, :cud, :general),
        data: task_updated_event_data(task)
      )
    end

    def task_updated_event_data(task)
      {
        producer: 'task-tracker_update_service',
        event_name: topics.dig(:tasks, :events, :updated),
        data: task.attributes.slice(*TASK_COLUMNS)
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
        producer: 'task-tracker_update_service',
        event_name: topics.dig(:tasks, :events, :finished),
        data: {
          public_id: task.public_id
        }
      }
    end
  end
end
