require 'spec_helper'

RSpec.describe CPScenario::Scenario do
  let(:api) { api_double }
  subject { CPScenario::Scenario.new(api, 1) }

  describe 'dataset' do
    it 'returns the API area code' do
      area_code = api.scenario_data(subject)['area_code']
      expect(subject.dataset).to eq(area_code)
    end
  end

  describe 'scaling_constant' do
    it 'returns number of households from the API' do
      expect(subject.scaling_constant).to eq(api.scaling_constant(subject))
    end
  end

  describe 'settings' do
    it 'returns an OpenStruct' do
      expect(subject.settings).to be_a(OpenStruct)
    end

    it 'returns the scenario settings' do
      # Symbolize keys.
      expected = api.scenario_data(subject)
        .each_with_object({}) do |(key, value), hash|
          hash[key.to_sym] = value
        end

      expect(subject.settings.to_h).to eq(expected)
    end
  end

  describe 'inputs, with two API inputs' do
    before { allow(api).to receive(:inputs).and_return(input_data) }

    let(:input_data) {
      [
        {
          'code' => 'abc',
          'min' => 0,
          'max' => 100,
          'unit' => '%',
          'user' => 10,
          'default' => 50
        },
        {
          'code' => 'xyz',
          'min' => 0,
          'max' => 100,
          'unit' => '%',
          'default' => 50
        }
      ]
    }

    it 'has two inputs' do
      expect(subject.inputs.count).to eq(2)
    end

    it 'has one user value' do
      expect(subject.inputs.user_values.count).to eq(1)
    end

    it 'defines the first input' do
      expect(subject.inputs.to_a.first.to_h)
        .to eq(CPScenario::Input.from_api(input_data.first).to_h)
    end

    it 'defines the second input' do
      expect(subject.inputs.to_a.last.to_h)
        .to eq(CPScenario::Input.from_api(input_data.last).to_h)
    end
  end
end
