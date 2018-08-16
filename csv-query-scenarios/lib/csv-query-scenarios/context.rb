# frozen_string_literal: true

module CSVQueryScenarios
  # Contains information about a request to fetch gquery results.
  #
  # Fields:
  #   server   - ETEngine server address with hostname.
  #   scenario - Scenario ID whose gqueries are to be fetched.
  #   gqueries - Array of gqueries to fetch.
  Context = Struct.new(:server, :scenario, :gqueries)
end
