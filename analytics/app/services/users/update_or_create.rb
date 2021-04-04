module Users
  class UpdateOrCreate
    COLUMNS = %w[public_id full_name email role].freeze

    def initialize(model: ::User)
      @model = model
    end

    def call(payload:)
      filtered_payload = payload.slice(*COLUMNS)

      existing_user = model.find_by(public_id: payload.dig('public_id'))
      return existing_user.update(filtered_payload) if existing_user.present?

      model.create(filtered_payload)
    end

    private

    attr_reader :model
  end
end
