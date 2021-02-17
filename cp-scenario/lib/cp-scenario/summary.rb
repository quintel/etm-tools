module CPScenario
  # Summarizes a copied scenario.
  class Summary
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

      out.puts pastel.green("Saved new scenario: #{@scenario.id}")
      out.puts
      out.puts "ETEngine: #{data_url}"
      out.puts "ETModel:  #{model_url}"
      out.puts

      errored = @scenario.inputs.user_values
        .reject { |input| input.user == input.user_bounded }

      num_inputs = @scenario.inputs.user_values.length

      if errored.none?
        out.puts pastel.green("#{num_inputs} inputs, 0 bounded")
      else
        out.puts 'Bounded:'

        errored.sort_by(&:key).each.with_index do |input, index|
          out.puts
          out.puts "  #{index + 1}) #{input.key}"
          out.puts
          out.puts pastel.red("          wanted: #{input.user}")
          out.puts pastel.red("         allowed: #{input.min} - #{input.max}")
          out.puts pastel.red("      bounded to: #{input.user_bounded}")
        end

        out.puts
        out.puts pastel.red("#{num_inputs} inputs, #{errored.length} bounded")
      end

      out.string
    end

    private

    def data_url
      "#{@scenario.api.endpoint}/data/#{@scenario.id}/scenarios/#{@scenario.id}"
    end

    def model_url
      "#{@scenario.api.endpoint.gsub(/engine/, 'pro')}/" \
        "scenarios/#{@scenario.id}"
    end
  end
end
