# frozen_string_literal: true

module CPScenario
  # Represents a scenario on an ETEngine server. Handles fetching inputs and
  # other information.
  class Scenario
    attr_reader :id, :api

    # Public: Sends a request to ETEngine to create a new blank scenario using
    # the given dataset.
    #
    # Returns the Scenario.
    def self.create(api, dataset, settings = {})
      data = api.create_scenario(dataset, settings)
      new(api, data['id'], settings: data)
    end

    # Public: Open a Scenario with the given ID. The scenario should already
    # exist on the server.
    def initialize(api, id, settings: nil)
      @api = api
      @id = id

      # Allows a call from create to provide the needed data without requiring
      # an extra HTTP request.
      @settings = OpenStruct.new(settings) unless settings.nil?
    end

    # Public: The key of the dataset used by the scenario.
    #
    # Returns a string.
    def dataset
      settings.area_code
    end

    # Public: Information about the scenario, including the dataset, end year,
    # etc.
    #
    # Returns an OpenStruct.
    def settings
      @settings ||= OpenStruct.new(@api.scenario_data(self))
    end

    # Public: An array containing all inputs for the scenario, including those
    # which the user has not changed.
    #
    # Returns an array of Inputs.
    def inputs
      @inputs ||= InputCollection.new(
        @api.inputs(self).map { |data| Input.from_api(data) }
      )
    end

    # Public: Returns the numeric constant which defines the size of the
    # scenario dataset relative to other scenarios.
    #
    # Returns a numeric.
    def scaling_constant
      @api.scaling_constant(self)
    end

    # Public: Saves the user values to the scenario.
    def save
      @api.update_scenario(self)
    end
  end
end
