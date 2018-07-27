module CPScenario
  # Sends and receives data from the ETEngine server.
  class API
    attr_reader :endpoint

    def initialize(endpoint)
      @endpoint = endpoint
    end

    # Public: Retrieves an array of all inputs in ETEngine, and any user values
    # assigned to the scenario.
    #
    # For example
    #
    #   api.inputs(scenario)
    #   #=> [{ 'code' => 'input_one', 'min' => 0, 'max' => 100 }, ...]
    #
    # Returns an Array.
    def inputs(scenario)
      request(:get, scenario, '/inputs', include_extras: true).values
    end

    # Fetches information about the scenario and the number of residences (used
    # to scale scenarios) in one request.
    #
    # Returns a Hash.
    def scenario_data(scenario)
      request(:put, scenario, '', gqueries: ['households_number_of_residences'])
    end

    # Public: Creates a new scenario for the given dataset key.
    #
    # dataset  - Key identifying the dataset for the scenario.
    # settings - Optional scenario data to be included.
    #
    # Returns a Hash.
    def create_scenario(dataset, settings = {})
      user_values = settings.delete(:user_values)

      JSON.parse(RestClient.post(
        "#{@endpoint}/api/v3/scenarios",
        {
          scenario: settings.merge(
            area_code: dataset,
            user_values: user_values,
            source: 'cp-scenario'
          )
        }.to_json,
        accept: :json,
        content_type: :json
      ))
    end

    # Public: Saves the user values to the scenario. Expects that the scenario
    # already exist.
    def update_scenario(scenario)
      request(:put, scenario, '', scenario: {
        user_values: scenario.inputs.user_values
      })
    end

    private

    # Internal: Sends a request to ETEngine.
    #
    # method - HTTP method to use.
    # path   - Optional path to append to the scenario URL.
    # params - Optional params (serialized as JSON)
    #
    # Returns the JSON-parsed response.
    def request(method, scenario, path = '', params = {})
      options = { accept: :json, content_type: :json }

      if method == :get
        options[:params] = params
        params = nil
      else
        params = params.to_json
      end

      JSON.parse(RestClient.public_send(
        method,
        "#{base_url(scenario)}#{path}",
        *[params, options].compact
      ))
    end

    def base_url(scenario)
      "#{@endpoint}/api/v3/scenarios/#{scenario.id}"
    end
  end
end
