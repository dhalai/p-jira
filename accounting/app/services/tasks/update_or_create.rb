module Tasks
  class UpdateOrCreate
    COLUMNS = %w[public_id title].freeze

    def initialize(model: ::Task)
      @model = model
    end

    def call(payload:)
      filtered_payload = payload.slice(*COLUMNS)

      existing_task = model.find_by(public_id: payload.dig('public_id'))
      return existing_task.update(filtered_payload) if existing_task.present?

      model.create(filtered_payload)
    end

    private

    attr_reader :model
  end
end
