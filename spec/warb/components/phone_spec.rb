# frozen_string_literal: true

RSpec.describe Warb::Components::Phone do
  describe '#to_h' do
    subject { phone.to_h }

    let(:phone) { described_class.new phone: '+5511...', type: 'WORK', wa_id: '5511...' }

    context 'built from given params' do
      it do
        expect(subject).to eq(
          {
            phone: '+5511...',
            type: 'WORK',
            wa_id: '5511...'
          }
        )
      end
    end

    context 'overwriting some values' do
      before do
        phone.type = 'HOME'
        phone.phone = '+5522...'
        phone.wa_id = '5522...'
      end

      it do
        expect(subject).to eq(
          {
            phone: '+5522...',
            type: 'HOME',
            wa_id: '5522...'
          }
        )
      end
    end
  end
end
