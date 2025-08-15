# frozen_string_literal: true

RSpec.describe Warb::Components::Email do
  describe '#to_h' do
    subject { email.to_h }

    let(:email) { described_class.new email: 'email@example.com', type: 'WORK' }

    context 'built from given params' do
      it do
        expect(subject).to eq(
          {
            email: 'email@example.com',
            type: 'WORK'
          }
        )
      end
    end

    context 'overwriting some values' do
      before do
        email.email = 'personal@example.com'
        email.type = 'HOME'
      end

      it do
        expect(subject).to eq(
          {
            email: 'personal@example.com',
            type: 'HOME'
          }
        )
      end
    end
  end
end
