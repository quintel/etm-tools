# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CSVQueryScenarios::CLIHelper do
  let(:arguments) { [] }
  let(:gqueries) { [] }
  let(:scenarios) { [] }

  let(:opts) do
    opts = instance_double(Slop::Result, arguments: arguments)

    allow(opts).to receive(:[]).with(:gqueries).and_return(gqueries)
    allow(opts).to receive(:[]).with(:scenarios).and_return(scenarios)

    opts
  end

  describe 'reading the server name' do
    let(:read_server) { described_class.server_from_opts(opts) }

    context 'when no name is given' do
      let(:arguments) { [] }

      it 'raises an error' do
        expect { read_server }.to raise_error('Unknown server: nil')
      end
    end

    context 'when the name is "beta"' do
      let(:arguments) { ['beta'] }

      it 'returns the staging server address' do
        expect(read_server)
          .to eq('https://beta-engine.energytransitionmodel.com')
      end
    end

    context 'when the name is "staging"' do
      let(:arguments) { ['staging'] }

      it 'returns the staging server address' do
        expect(read_server)
          .to eq('https://beta-engine.energytransitionmodel.com')
      end
    end

    context 'when the name is "production"' do
      let(:arguments) { ['production'] }

      it 'returns the production server address' do
        expect(read_server).to eq('https://engine.energytransitionmodel.com')
      end
    end

    context 'when the name is "pro"' do
      let(:arguments) { ['pro'] }

      it 'returns the production server address' do
        expect(read_server).to eq('https://engine.energytransitionmodel.com')
      end
    end

    context 'when the name is "PRO"' do
      let(:arguments) { ['PRO'] }

      it 'returns the production server address' do
        expect(read_server).to eq('https://engine.energytransitionmodel.com')
      end
    end

    context 'when the name is "live"' do
      let(:arguments) { ['live'] }

      it 'returns the production server address' do
        expect(read_server).to eq('https://engine.energytransitionmodel.com')
      end
    end

    context 'when the name is "http://localhost"' do
      let(:arguments) { ['http://localhost'] }

      it 'returns the staging server address' do
        expect(read_server).to eq('http://localhost')
      end
    end

    context 'when the name is "https://localhost"' do
      let(:arguments) { ['https://localhost'] }

      it 'returns the staging server address' do
        expect(read_server).to eq('https://localhost')
      end
    end

    context 'when the name is "httpno"' do
      let(:arguments) { ['httpno'] }

      it 'raises an error' do
        expect { read_server }.to raise_error('Unknown server: "httpno"')
      end
    end

    context 'when the name is ""' do
      let(:arguments) { [''] }

      it 'raises an error' do
        expect { read_server }.to raise_error('Unknown server: ""')
      end
    end

    context 'when the name is "nope"' do
      let(:arguments) { ['nope'] }

      it 'raises an error' do
        expect { read_server }.to raise_error('Unknown server: "nope"')
      end
    end

    context 'when the name is nil' do
      let(:arguments) { [nil] }

      it 'raises an error' do
        expect { read_server }.to raise_error('Unknown server: nil')
      end
    end
  end

  describe '.gqueries_from_opts' do
    let(:read_gqueries) { described_class.gqueries_from_opts(opts) }

    context 'with --gqueries one,two,three' do
      let(:gqueries) { %w[one two three] }

      it 'returns [one, two, three]' do
        expect(read_gqueries).to eq(%w[one two three])
      end
    end

    context 'with --gqueries one,two,,three,,four' do
      let(:gqueries) { ['one', 'two', '', 'three', '', 'four'] }

      it 'returns [one, two, three, four]' do
        expect(read_gqueries).to eq(%w[one two three four])
      end
    end

    context 'with gqueries=[]' do
      let(:gqueries) { [] }

      it 'raises an error' do
        expect { read_gqueries }
          .to raise_error('Please specify at least one gquery')
      end
    end

    context 'with gqueries=nil' do
      let(:gqueries) { nil }

      it 'raises an error' do
        expect { read_gqueries }
          .to raise_error('Please specify at least one gquery')
      end
    end
  end

  describe '.scenarios_from_opts' do
    let(:read_scenarios) { described_class.scenarios_from_opts(opts) }

    context 'with --scenarios 1,2,3' do
      let(:scenarios) { %w[1 2 3] }

      it 'returns [1, 2, 3]' do
        expect(read_scenarios).to eq([1, 2, 3])
      end
    end

    context 'with --scenarios 1,2,,3,,4' do
      let(:scenarios) { ['1', '2', '', '3', '', '4'] }

      it 'returns [1, 2, 3, 4]' do
        expect(read_scenarios).to eq([1, 2, 3, 4])
      end
    end

    context 'with scenarios=[]' do
      let(:scenarios) { [] }

      it 'raises an error' do
        expect { read_scenarios }
          .to raise_error('Please specify at least one scenario ID')
      end
    end

    context 'with scenarios=nil' do
      let(:scenarios) { nil }

      it 'raises an error' do
        expect { read_scenarios }
          .to raise_error('Please specify at least one scenario ID')
      end
    end
  end
end
