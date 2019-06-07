module CPScenario
  # Receives a scenario and creates a clone at the chosen API.
  class Action
    attr_reader :api, :errors, :scenario, :source

    # Public: Create an Action, clones a scenario.
    #
    # source  - The source scenario.
    # api     - API where the new scenario will be saved.
    # dataset - Optional dataset key. Allows the new scenario to be saved with a
    #           different dataset to the source.
    #
    # Returns an Action.
    def initialize(source, api, dataset = nil, protect = false)
      @source   = source
      @api      = api
      @dataset  = dataset
      @protect  = protect
      @success  = nil
      @errors   = []
    end

    def dataset
      @dataset || @source.dataset
    end

    def success?
      @success
    end

    def call
      @scenario = CPScenario::Scenario.create(
        api,
        dataset,
        end_year: source.settings.end_year,
        protected: @protect
      )

      @scenario.inputs.assign(CPScenario::Scaler.new(
        source.inputs.user_values,
        @scenario.scaling_constant / source.scaling_constant
      ).inputs)

      @scenario.save

      @success = true
      @scenario
    rescue RestClient::UnprocessableEntity => ex
      errs = JSON.parse(ex.http_body)['errors']

      @errors = if errs.is_a?(Array)
        errs
      else
        errs.flat_map do |attribute, errors|
          errors.map { |error| "#{attribute} #{error}" }
        end
      end

      @success = false
    rescue RestClient::Exception => ex
      @errors = ["#{ex}\n#{ex.http_body}"]
      @success = false
    rescue => ex
      @errors = ["#{ex.message}\n#{ex.backtrace}"]
      @success = false
    end
  end
end
