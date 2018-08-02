# frozen_string_literal: true

require 'json'
require 'ostruct'

require 'rest-client'

require_relative 'cp-scenario/action'
require_relative 'cp-scenario/api'
require_relative 'cp-scenario/compact_summary'
require_relative 'cp-scenario/input'
require_relative 'cp-scenario/input_collection'
require_relative 'cp-scenario/scaler'
require_relative 'cp-scenario/scenario'
require_relative 'cp-scenario/summary'

module CPScenario
  # Takes an endpoint name from the command-line and returns the host.
  def self.translate_endpoint(endpoint)
    case endpoint
    when 'beta'
      'https://beta-engine.energytransitionmodel.com'
    when 'production'
      'https://engine.energytransitionmodel.com'
    when /\Ahttp/
      endpoint.chomp('/')
    else
      raise "Unknown ETEngine address: #{endpoint.inspect}"
    end
  end
end
