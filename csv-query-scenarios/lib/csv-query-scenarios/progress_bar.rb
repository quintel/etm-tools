# frozen_string_literal: true

module CSVQueryScenarios
  class ProgressBar
    # Public: Creates a new ProgressBar reducer when the given `io` (to which
    # the CSV will be written) is not a TTY; this is the case when redirecting
    # output to a file.
    #
    # If the CSV is being written directly to the terminal the progress bar is
    # disabled to make the output easier to read.
    def self.create_for_io(io, length, write_to: $stderr)
      if io.isatty
        ->(_context, result) { result }
      else
        new(length, write_to: write_to)
      end
    end

    def initialize(length, write_to: $stderr)
      @bar ||= TTY::ProgressBar.new(
        'Fetching queries [:bar] (:current/:total)',
        output: write_to,
        total: length,
        width: TTY::ProgressBar.max_columns
      )
    end

    def call(_context, result)
      @bar.advance(1)
      result
    end
  end
end
