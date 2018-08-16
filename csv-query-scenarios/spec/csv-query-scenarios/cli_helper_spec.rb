# frozen_string_literal: true

require 'spec_helper'

RSpec.describe CSVQueryScenarios::CLIHelper, '.server_from_opts' do
  let(:arguments) { [] }
  let(:opts) { instance_double(Slop::Result, arguments: arguments) }

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

RSpec.describe CSVQueryScenarios::CLIHelper, '.gqueries_from_opts' do
  let(:gqueries) { [] }
  let(:gqueries_path) { nil }

  let(:opts) do
    instance_double(Slop::Result).tap do |res|
      allow(res).to receive(:[]).with(:gqueries).and_return(gqueries)
      allow(res).to receive(:[]).with(:gqueries_file).and_return(gqueries_path)
    end
  end

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

  context 'with --gqueries-file' do
    let(:gqueries_path) { gqueries_file.path }

    let(:gqueries_file) do
      file = Tempfile.new('gqueries')
      file.write(gqueries_file_content)
      file.rewind
      file
    end

    after { gqueries_file.unlink }

    context 'with an empty-file' do
      let(:gqueries_file_content) { '' }

      it 'raises an error' do
        expect { read_gqueries }
          .to raise_error('Please specify at least one gquery')
      end
    end

    context 'with gquery_one' do
      let(:gqueries_file_content) { 'gquery_one' }

      it 'returns [gquery_one]' do
        expect(read_gqueries).to eq(%w[gquery_one])
      end
    end

    context 'with gquery_one, gquery_two, gquery_one' do
      let(:gqueries_file_content) do
        <<~GQUERIES
          gquery_one
          gquery_two
          gquery_one
        GQUERIES
      end

      it 'returns [gquery_one, gquery_two]' do
        expect(read_gqueries).to eq(%w[gquery_one gquery_two])
      end
    end

    context "when the file doesn't exist" do
      let(:gqueries_path) { 'no/such/file' }
      let(:gqueries_file_content) { '' }

      it 'raises an error' do
        expect { read_gqueries }.to raise_error(/no such file/i)
      end
    end

    context 'when --gqueries is also specified' do
      let(:gqueries_file_content) { '' }
      let(:gqueries) { %w[one two three] }

      it 'raises an error' do
        expect { read_gqueries }.to raise_error(
          '--gqueries and --gqueries-file are mutually exclusive; ' \
          "don't specify both"
        )
      end
    end
  end
end

RSpec.describe CSVQueryScenarios::CLIHelper, '.scenarios_from_opts' do
  let(:scenarios) { [] }
  let(:scenarios_path) { nil }

  let(:opts) do
    instance_double(Slop::Result).tap do |res|
      allow(res).to receive(:[]).with(:scenarios).and_return(scenarios)
      allow(res).to receive(:[]).with(:scenarios_file).and_return(scenarios_path)
    end
  end

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

  context 'with --scenarios-file' do
    let(:scenarios_path) { scenarios_file.path }

    let(:scenarios_file) do
      file = Tempfile.new('scenarios')
      file.write(scenarios_file_content)
      file.rewind
      file
    end

    after { scenarios_file.unlink }

    context 'with an empty-file' do
      let(:scenarios_file_content) { '' }

      it 'raises an error' do
        expect { read_scenarios }
          .to raise_error('Please specify at least one scenario ID')
      end
    end

    context 'with 1' do
      let(:scenarios_file_content) { '1' }

      it 'returns [1]' do
        expect(read_scenarios).to eq([1])
      end
    end

    context 'with 1,2,3' do
      let(:scenarios_file_content) { "1\n2\n3" }

      it 'returns [1, 2, 3]' do
        expect(read_scenarios).to eq([1, 2, 3])
      end
    end

    context "when the file doesn't exist" do
      let(:scenarios_path) { 'no/such/file' }
      let(:scenarios_file_content) { '' }

      it 'raises an error' do
        expect { read_scenarios }.to raise_error(/no such file/i)
      end
    end

    context 'when --scenarios is also specified' do
      let(:scenarios_file_content) { '' }
      let(:scenarios) { %w[1 2 3] }

      it 'raises an error' do
        expect { read_scenarios }.to raise_error(
          '--scenarios and --scenarios-file are mutually exclusive; ' \
          "don't specify both"
        )
      end
    end
  end
end
