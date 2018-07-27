require 'spec_helper'

RSpec.describe CPScenario::InputCollection do
  let(:subject) do
    CPScenario::InputCollection.new([
      CPScenario::Input.from_hash(key: 'abc', user: 1),
      CPScenario::Input.from_hash(key: 'xyz', user: 3),
    ])
  end

  describe '#assign' do
    context 'given a value for :abc' do
      let(:new_vals) { [CPScenario::Input.from_hash(key: 'abc', user: 2)] }

      it 'changes the collection value' do
        expect { subject.assign(new_vals) }
          .to change { subject.get('abc').user }
          .from(1).to(2)
      end

      it 'does not modify ungiven inputs' do
        expect { subject.assign(new_vals) }
          .not_to change { subject.get('xyz').user }
          .from(3)
      end
    end
  end
end
