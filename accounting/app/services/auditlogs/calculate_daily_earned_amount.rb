module Auditlogs
  class CalculateDailyEarnedAmount
    def initialize(model: ::Auditlog)
      @model = model
    end

    def call
      model.connection.execute(query).first['total'].to_i
    end

    private

    attr_reader :model

    def query
      "SELECT -ROUND(SUM(credit) - SUM(debit), 0) AS total
      FROM #{model.table_name}
      WHERE created_at BETWEEN '#{Date.current.beginning_of_day}' AND '#{Date.current.end_of_day}'"
    end
  end
end
