# frozen_string_literal: true

require 'ostruct'

module CSVQueryScenarios
  # Helper methods for the executable.
  module CLIHelper
    module_function

    # Public: Reads the command line options from the Slop options hash,
    # performs some basic validation and returns an OpenStruct with the config.
    def configuration(opts)
      OpenStruct.new(
        gqueries: gqueries_from_opts(opts),
        output: $stdout,
        scenarios: scenarios_from_opts(opts),
        server: server_from_opts(opts)
      )
    end

    # Internal: Reads the gqueries from the parse Slop options hash.
    #
    # Returns an array of strings.
    def gqueries_from_opts(opts)
      assert_exclusive_collection_options!(opts, :gqueries)

      gqueries = file_or_collection(opts[:gqueries_file], opts[:gqueries])
      raise 'Please specify at least one gquery' if gqueries.empty?

      gqueries
    end

    # Internal: Reads the scenario IDs from the parse Slop options hash.
    #
    # Returns an array of integers.
    def scenarios_from_opts(opts)
      assert_exclusive_collection_options!(opts, :scenarios)

      scenarios = file_or_collection(opts[:scenarios_file], opts[:scenarios])
      raise 'Please specify at least one scenario ID' if scenarios.empty?

      scenarios.map { |id| Integer(id) }
    end

    # Internal: Reads and validates the server name from the parsed Slop
    # options hash.
    #
    # Returns a string.
    def server_from_opts(opts)
      value = opts.arguments.first

      case value.to_s.downcase
      when 'production', 'pro', 'live'
        'https://engine.energytransitionmodel.com'
      when 'beta', 'staging'
        'https://beta-engine.energytransitionmodel.com'
      when %r{\Ahttps?://}
        value
      else
        raise "Unknown server: #{value.inspect}"
      end
    end

    # Returns a collection by reading the path (one element per line), when path
    # is non-nil, or returns the enum as an array.
    def file_or_collection(path, enum)
      return collection(enum) unless path

      raise "No such file: #{path.inspect}" unless File.exist?(path)

      collection(File.foreach(path).map(&:strip))
    end

    private_class_method :file_or_collection

    # Takes an array argument from Slop and returns an array of non-empty
    # members.
    def collection(enum)
      (enum.to_a || []).reject(&:empty?).uniq
    end

    private_class_method :collection

    # Asserts that the user didn't provide both --option and --option-file
    # arguments.
    def assert_exclusive_collection_options!(opts, option)
      return if !opts[:"#{option}_file"] || collection(opts[option]).none?

      raise(
        "--#{option} and --#{option}-file are mutually exclusive; " \
        "don't specify both"
      )
    end

    private_class_method :assert_exclusive_collection_options!
  end
end
