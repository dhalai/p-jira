module Tasks
  class Build
    def initialize(
      model: Task,
      randomizer: SecureRandom
    )
      @model = model
      @randomizer = randomizer
    end

    def call(params:)
      model.new(
        params.merge(
          public_id: randomizer.uuid
        )
      )
    end

    private

    attr_reader :model, :randomizer
  end
end
