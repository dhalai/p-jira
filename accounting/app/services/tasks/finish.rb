module Tasks
  class Finish
    class UnexistingTask < StandardError; end
    class UnexistingUser < StandardError; end

    def initialize(
      task_model: Task,
      auditlog_creator: Auditlogs::Create,
      price_calculator: Auditlogs::CalculatePrice
    )
      @task_model = task_model
      @auditlog_creator = auditlog_creator
      @price_calculator = price_calculator
    end

    def call(payload:)
      task = task_model.find_by(public_id: payload.dig('public_id'))
      user = task.user

      # backoff in case there're no such items
      raise UnexistingTask unless task
      raise UnexistingUser unless user

      credit = price_calculator.new.call
      task.transaction do
        task.done!
        user.update(balance: user.balance.to_i + credit)
        auditlog_creator.new.call(
          data: auditlog_data(task, credit)
        )
      end
    end

    private

    attr_reader :task_model, :auditlog_creator, :price_calculator

    def auditlog_data(task, credit)
      {
        task_id: task.id,
        user_id: task.user_id,
        credit: credit
      }
    end
  end
end
