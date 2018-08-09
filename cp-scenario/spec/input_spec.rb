require 'spec_helper'

RSpec.describe CPScenario::Input do
  describe '.from_api' do
    subject { CPScenario::Input.from_api(attributes) }

    context 'with all attributes provided' do
      let(:attributes) do
        {
          'code' => 'abc',
          'min' => 10,
          'max' => 90,
          'unit' => '%',
          'default' => 50,
          'user' => 25
        }
      end

      it('assigns the key') { expect(subject.key).to eq('abc') }
      it('assigns the min') { expect(subject.min).to eq(10) }
      it('assigns the max') { expect(subject.max).to eq(90) }
      it('assigns the unit') { expect(subject.unit).to eq('%') }
      it('assigns the default') { expect(subject.default).to eq(50) }
      it('assigns the user value') { expect(subject.user).to eq(25) }
    end
  end

  describe '.from_hash' do
    subject { CPScenario::Input.from_hash(attributes) }

    context 'with all attributes provided' do
      let(:attributes) do
        { key: 'abc', min: 10, max: 90, unit: '%', default: 50, user: 25 }
      end

      it('assigns the key') { expect(subject.key).to eq('abc') }
      it('assigns the min') { expect(subject.min).to eq(10) }
      it('assigns the max') { expect(subject.max).to eq(90) }
      it('assigns the unit') { expect(subject.unit).to eq('%') }
      it('assigns the default') { expect(subject.default).to eq(50) }
      it('assigns the user value') { expect(subject.user).to eq(25) }
    end

    context 'with no user value' do
      let(:attributes) do
        { key: 'abc', min: 10, max: 90, unit: '%', default: 50 }
      end

      it('assigns the key') { expect(subject.key).to eq('abc') }
      it('assigns the min') { expect(subject.min).to eq(10) }
      it('assigns the max') { expect(subject.max).to eq(90) }
      it('assigns the unit') { expect(subject.unit).to eq('%') }
      it('assigns the default') { expect(subject.default).to eq(50) }
      it('sets no user value') { expect(subject.user).to be_nil }
    end
  end

  context 'with min=10, max=90' do
    subject { CPScenario::Input.from_hash(attributes) }

    let(:attributes) { { min: 10, max: 90 } }

    context 'and user=50' do
      let(:attributes) { super().merge(user: 50) }

      it('has a user value of 50') do
        expect(subject.user).to eq(50)
      end

      it('has a user_bounded value of 50') do
        expect(subject.user_bounded).to eq(50)
      end
    end

    context 'and user=5' do
      let(:attributes) { super().merge(user: 5) }

      it('has a user value of 5') do
        expect(subject.user).to eq(5)
      end

      it('has a user_bounded value of 10') do
        expect(subject.user_bounded).to eq(10)
      end
    end

    context 'and user=100' do
      let(:attributes) { super().merge(user: 100) }

      it('has a user value of 100') do
        expect(subject.user).to eq(100)
      end

      it('has a user_bounded value of 90') do
        expect(subject.user_bounded).to eq(90)
      end
    end
  end

  context 'with unit=%' do
    subject { CPScenario::Input.from_hash(attributes) }
    let(:attributes) { { unit: '%' } }

    it('is not scaleable') { expect(subject).to_not be_scaleable }
  end

  context 'with unit=#' do
    subject { CPScenario::Input.from_hash(attributes) }
    let(:attributes) { { unit: '#' } }

    it('is scaleable') { expect(subject).to be_scaleable }
  end
end
