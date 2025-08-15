# frozen_string_literal: true

RSpec.describe Warb::Components::URL do
  describe '#to_h' do
    subject { url.to_h }

    let(:url) { described_class.new url: 'url', type: 'WORK' }

    context 'built from given params' do
      it do
        expect(subject).to eq(
          {
            type: 'WORK',
            url: 'url'
          }
        )
      end
    end

    context 'overwriting some values' do
      before do
        url.type = 'HOME'
      end

      it do
        expect(subject).to eq(
          {
            type: 'HOME',
            url: 'url'
          }
        )
      end
    end
  end
end
