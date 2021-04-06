module Auditlogs
  class CalculateMostExpensiveTask
    def initialize(
      auditlog_model: Auditlog,
      task_model: Task
    )
      @auditlog_model = auditlog_model
      @task_model = task_model
    end

    #TODO: add cache logic
    def call(date_range:)
      task = most_expensive_task(date_range)

      OpenStruct.new(
        task: task_model.find_by(id: task['task_id']),
        price: task['debit']
      )
    end

    private

    attr_reader :auditlog_model, :task_model

    def most_expensive_task(date_range)
      finished_task_ids = finished_tasks(date_range)
      return {} unless finished_task_ids.present?

      auditlog_model.connection.execute(
        most_expensive_task_query(finished_task_ids)
      ).first
    end

    def finished_tasks(date_range)
      auditlog_model.connection.execute(
        finished_tasks_ids_query(date_range)
      ).to_a.map { |record| record['task_id'] }
    end

    def finished_tasks_ids_query(date_range)
      "SELECT DISTINCT(task_id)
      FROM #{auditlog_model.table_name}
      WHERE created_at BETWEEN '#{date_range.first}' AND '#{date_range.last}'
      AND task_id IS NOT NULL
      AND credit > 0"
    end

    def most_expensive_task_query(task_ids)
      "SELECT task_id, debit
      FROM #{auditlog_model.table_name}
      WHERE id IN(
        SELECT id
        FROM (
          SELECT id, task_id
          FROM #{auditlog_model.table_name}
          WHERE task_id IN(#{task_ids.map { |id| "'#{id}'"  }.join(',')})
          AND debit > 0
          GROUP BY task_id, id
          ORDER BY created_at DESC
        ) as most_recent_tasks
      )
      ORDER BY debit DESC
      LIMIT 1"
    end
  end
end
