# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CSVQueryScenarios::CSVBuilder do
  let(:result) { described_class.call(context, input) }

  context 'with requested gqueries query_one, query_two' do
    let(:context) do
      CSVQueryScenarios::Context.new('', 1, %w[query_one query_two])
    end

    context 'with input of query_one=1, query_two=2, query_three=3' do
      let(:input) do
        {
          'query_one' => { 'present' => 10, 'future' => 1, 'unit' => '%' },
          'query_two' => { 'present' => 20, 'future' => 2, 'unit' => 'x' },
          'query_three' => { 'present' => 30, 'future' => 3, 'unit' => 'x' }
        }
      end

      it 'starts with the scenario ID' do
        expect(result).to start_with('1,')
      end

      it 'includes the query_one value' do
        expect(result).to include(',1,')
      end

      it 'includes the query_two value' do
        expect(result).to include(',2')
      end

      it 'does not include the query_three value' do
        expect(result).not_to include(',3')
      end
    end

    context 'with input of query_one=1' do
      let(:input) do
        { 'query_one' => { 'present' => 10, 'future' => 1, 'unit' => '%' } }
      end

      it 'raises a key error' do
        expect { result }.to raise_exception(KeyError)
      end
    end
  end
end
