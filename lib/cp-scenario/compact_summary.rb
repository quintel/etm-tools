# frozen_string_literal: true

module CPScenario
  # Summarizes a copied scenario.
  class CompactSummary
    def self.call(scenario, pastel)
      new(scenario).summarize_copy(pastel)
    end

    def initialize(scenario)
      @scenario = scenario
    end

    # Public: Produces a summary of the copied scenario.
    #
    # Returns a String.
    def summarize_copy(pastel)
      out = StringIO.new

      errored = @scenario.inputs.user_values
        .reject { |input| input.user == input.user_bounded }

      prefix = "#{@scenario.dataset}: #{@scenario.id}"

      if errored.none?
        out.puts pastel.green(prefix)
      else
        num_inputs = @scenario.inputs.user_values.length

        out.puts pastel.yellow(
          "#{prefix} (#{num_inputs} inputs, #{errored.length} bounded)"
        )
      end

      out.string
    end
  end
end
