# frozen_string_literal: true

module CSVQueryScenarios
  # Writes a line of CSV output to the `io`. Writes the CSV headers immediately
  # prior to writing the first line of values.
  class IOWriter
    def initialize(io)
      @io = io
      @has_output_headers = false
    end

    def call(context, result)
      write_headers(context)
      @io.puts(result)
    end

    private

    def write_headers(context)
      return if @has_output_headers
      @has_output_headers = true

      @io.puts(CSV.generate_line(['scenario', *context.gqueries]))
    end
  end
end
