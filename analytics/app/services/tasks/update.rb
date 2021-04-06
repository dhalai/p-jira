module Tasks
  class Update
    def initialize(model: ::Task)
      @model = model
    end

    def call(payload:)
      existing_task = model.find_by(public_id: payload.dig('public_id'))
      existing_task.update(payload) if existing_task.present?
    end

    private

    attr_reader :model
  end
end
