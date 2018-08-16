# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CSVQueryScenarios::ProgressBar do
  let(:output_io) { StringIO.new }
  let(:bar) { described_class.create_for_io(io, 2, write_to: output_io) }

  before do
    # Needed to trick tty-progressbar into writing output.
    allow(output_io).to receive(:tty?).and_return(true)
  end

  describe '.create_for_io' do
    context 'when given STDOUT' do
      let(:io) { STDOUT }

      it 'does not return a ProgressBar' do
        expect(bar).not_to be_a(described_class)
      end

      it 'returns a callable' do
        expect(bar).to respond_to(:call)
      end

      it 'returns the given result when called' do
        expect(bar.call(nil, :hi)).to eq(:hi)
      end

      it 'writes nothing when called' do
        bar.call(nil, nil)
        output_io.rewind

        expect(output_io.read).to eq('')
      end
    end

    context 'when given a StringIO' do
      let(:io) { StringIO.new }

      it 'returns a ProgressBar' do
        expect(bar).to be_a(described_class)
      end

      it 'returns a callable' do
        expect(bar).to respond_to(:call)
      end

      it 'returns the given result when called' do
        expect(bar.call(nil, :hi)).to eq(:hi)
      end

      it 'advances the bar the first time it is called' do
        bar.call(nil, nil)
        output_io.rewind

        expect(output_io.read).to include('1/2')
      end

      it 'advances the bar the second time it is called' do
        2.times { bar.call(nil, nil) }
        output_io.rewind

        expect(output_io.read).to include('2/2')
      end
    end
  end
end
