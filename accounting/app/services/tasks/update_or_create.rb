module Tasks
  class UpdateOrCreate
    COLUMNS = %w[public_id title].freeze

    def initialize(
      model: ::Task,
      creator: Tasks::Create,
      updater: Tasks::Update
    )
      @model = model
      @creator = creator
      @updater = updater
    end

    def call(payload:)
      filtered_payload = payload.slice(*COLUMNS)

      existing_task = model.find_by(public_id: payload.dig('public_id'))
      return updater.new.call(payload: filtered_payload) if existing_task.present?

      creator.new.call(payload: filtered_payload)
    end

    private

    attr_reader :model, :creator, :updater
  end
end
