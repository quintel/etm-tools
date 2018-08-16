# frozen_string_literal: true

require 'csv'
require 'json'
require 'pathname'

require 'rest-client'
require 'pastel'

require_relative 'csv-query-scenarios/cli_helper'
require_relative 'csv-query-scenarios/context'
require_relative 'csv-query-scenarios/csv_builder'
require_relative 'csv-query-scenarios/fetch'
require_relative 'csv-query-scenarios/io_writer'
require_relative 'csv-query-scenarios/progress_bar'

module CSVQueryScenarios
  module_function

  # Public: An array of the reducers used to fetch and dump data for a scenario.
  def reducers(config)
    [
      CSVQueryScenarios::Fetch,
      CSVQueryScenarios::CSVBuilder,
      CSVQueryScenarios::IOWriter.new(config.output),
      CSVQueryScenarios::ProgressBar.create_for_io(
        config.output, config.scenarios.length
      )
    ]
  end

  # Public: Executes a series of reduced on the given context.
  def execute(context, reducers)
    reducers.reduce(nil) do |result, reducer|
      reducer.call(context, result)
    end
  end
end
