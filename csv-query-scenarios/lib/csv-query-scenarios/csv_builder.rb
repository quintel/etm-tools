# frozen_string_literal: true

module CSVQueryScenarios
  # Builds a CSV from each set of gquery results.
  CSVBuilder = lambda do |context, result|
    CSV.generate_line([
      context.scenario,
      *context.gqueries.map { |gquery| result.fetch(gquery)['future'] }
    ])
  end
end
