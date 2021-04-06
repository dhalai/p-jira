module Tasks
  class Create
    def initialize(model: ::Task)
      @model = model
    end

    def call(payload:)
      model.create(payload)
    end

    private

    attr_reader :model
  end
end
