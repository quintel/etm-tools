# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CSVQueryScenarios::Fetch do
  context 'with server=http://localhost:3000 scenario=10 gqueries=a,b,c' do
    let(:context) do
      CSVQueryScenarios::Context.new('http://localhost:3000', 10, %w[a b c])
    end

    it 'sends a request to the server' do
      allow(RestClient).to receive(:put)
        .and_return(instance_double(RestClient::Response, body: '{}'))

      described_class.call(context, nil)

      expect(RestClient).to have_received(:put).with(
        'http://localhost:3000/api/v3/scenarios/10',
        { gqueries: context.gqueries }.to_json,
        accept: :json,
        content_type: :json
      )
    end

    it 'returns the gqueries as a hash' do
      allow(RestClient).to receive(:put).and_return(instance_double(
        RestClient::Response,
        body: '{ "gqueries": { "a": 1, "b": 2, "c": 3 } }'
      ))

      expect(described_class.call(context, nil)).to eq(
        'a' => 1, 'b' => 2, 'c' => 3
      )
    end
  end
end
