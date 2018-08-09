require 'spec_helper'

RSpec.describe CPScenario::Scaler do
  let(:scenario) do
    CPScenario::Scenario.new(api_double, 1)
  end

  describe 'scaling by 0.5' do
    let(:scaled) { CPScenario::Scaler.new(inputs, 0.5).inputs }

    context 'with a scaleable input' do
      let(:inputs) do
        [CPScenario::Input.from_hash(user: 50, unit: '#')]
      end

      it 'returns a new input object' do
        expect(scaled.first.object_id).to_not eq(inputs.first.object_id)
      end

      it 'scales the user value' do
        expect(scaled.first.user).to eq(25)
      end
    end

    context 'with an unscaleable input' do
      let(:inputs) do
        [CPScenario::Input.from_hash(user: 50, unit: '%')]
      end

      it 'returns a new input object' do
        expect(scaled.first.object_id).to_not eq(inputs.first.object_id)
      end

      it 'does not scale the user value' do
        expect(scaled.first.user).to eq(50)
      end
    end
  end

  describe 'scaling by 2.0' do
    let(:scaled) { CPScenario::Scaler.new(inputs, 2.0).inputs }

    context 'with a scaleable input' do
      let(:inputs) do
        [CPScenario::Input.from_hash(user: 50, unit: '#')]
      end

      it 'returns a new input object' do
        expect(scaled.first.object_id).to_not eq(inputs.first.object_id)
      end

      it 'scales the user value' do
        expect(scaled.first.user).to eq(100)
      end
    end

    context 'with an unscaleable input' do
      let(:inputs) do
        [CPScenario::Input.from_hash(user: 50, unit: '%')]
      end

      it 'returns a new input object' do
        expect(scaled.first.object_id).to_not eq(inputs.first.object_id)
      end

      it 'does not scale the user value' do
        expect(scaled.first.user).to eq(50)
      end
    end
  end
end
