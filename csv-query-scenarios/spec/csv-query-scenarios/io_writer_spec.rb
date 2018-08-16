# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CSVQueryScenarios::IOWriter do
  let(:io) { StringIO.new }
  let(:input) { '1,2,3,4' }
  let(:writer) { described_class.new(io) }
  let(:output) { io.rewind && io.read }

  context 'with gqueries a,b,c' do
    let(:context) { CSVQueryScenarios::Context.new('', 1, %w[a b c]) }

    before { writer.call(context, input) }

    it 'outputs the CSV headers on the first call' do
      expect(output).to start_with("scenario,a,b,c\n")
    end

    it 'outputs the row values' do
      expect(output).to end_with("1,2,3,4\n")
    end

    context 'when called again' do
      before { writer.call(context, '5,6,7,8') }

      it 'does not output headers on the second call' do
        expect(output.scan("scenario,a,b,c\n").length).to eq(1)
      end

      it 'includes the first row values' do
        expect(output).to include("1,2,3,4\n")
      end

      it 'outputs the second row values' do
        expect(output).to end_with("5,6,7,8\n")
      end
    end
  end
end
