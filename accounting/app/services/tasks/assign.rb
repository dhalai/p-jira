module Tasks
  class Assign
    class UnexistingTask < StandardError; end
    class UnexistingUser < StandardError; end

    def initialize(
      task_model: Task,
      user_model: User,
      auditlog_creator: Auditlogs::Create
    )
      @task_model = task_model
      @user_model = user_model
      @auditlog_creator = auditlog_creator
    end

    def call(payload:)
      task = task_model.find_by(public_id: payload.dig('public_id'))
      user = user_model.find_by(public_id: payload.dig('assignee_id'))

      # backoff in case there're no such items
      # return unless task && user
      raise UnexistingTask unless task
      raise UnexistingUser unless user

      debit = task.price
      task.transaction do
        task.update(user_id: user.id)
        user.update(balance: user.balance.to_i - debit)
        auditlog_creator.new.call(data: auditlog_data(task, debit))
      end
    end

    private

    attr_reader :task_model, :user_model, :auditlog_creator

    def auditlog_data(task, debit)
      {
        task_id: task.id,
        user_id: task.user_id,
        debit: debit
      }
    end
  end
end
