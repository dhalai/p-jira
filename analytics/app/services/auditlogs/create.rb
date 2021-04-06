module Auditlogs
  class Create
    class UnexistingUser < StandardError; end

    def initialize(
      auditlog_model: Auditlog,
      user_model: User,
      task_model: Task
    )
      @auditlog_model = auditlog_model
      @user_model = user_model
      @task_model = task_model
    end

    def call(payload:)
      user = user_model.find_by(public_id: payload['user_id'])
      # backoff in case there're no such items
      # return unless user
      raise UnexistingUser unless user

      task = task_model.find_by(public_id: payload['task_id'])

      auditlog_model.create(
        payload.except('user_id', 'task_id').merge(
          user_id: user.id,
          task_id: task&.id
        )
      )
    end

    private

    attr_reader :auditlog_model, :user_model, :task_model
  end
end
