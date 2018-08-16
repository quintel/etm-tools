# frozen_string_literal: true

module CSVQueryScenarios
  # Public: Fetches gquery results from an ETEngine server.
  #
  # server    - Address of the ETEngine server to query, including protocol.
  # scenarios - An array of scenario IDs to be queried.
  # gqueries  - An array of gqueries to fetch.
  #
  # For example:
  #
  #   fetch(
  #     'https://beta-engine.energytransitionmodel.com',
  #     [1, 2, 3]
  #     %w[gquery_one gquery_two gquery_three]
  #   )
  #
  # Returns a Context.
  Fetch = lambda do |context, _result|
    response = RestClient.put(
      "#{context.server}/api/v3/scenarios/#{context.scenario}",
      { gqueries: context.gqueries }.to_json,
      accept: :json,
      content_type: :json
    )

    JSON.parse(response.body)['gqueries']
  end
end
