# frozen_string_literal: true

RSpec.describe Warb::Resources::Sticker do
  let(:sticker_resource) { described_class.new media_id: 'media_id', link: 'media_link' }

  describe '#build_header' do
    it do
      expect { sticker_resource.build_header }.to raise_error NotImplementedError
    end
  end

  describe '#build_payload' do
    subject { sticker_resource.build_payload }

    it do
      expect(subject).to eq(
        {
          type: 'sticker',
          sticker: {
            id: 'media_id',
            link: 'media_link'
          }
        }
      )
    end
  end

  context 'priorities' do
    subject { sticker_resource.build_payload[:sticker] }

    before do
      allow(sticker_resource).to receive_messages(
        {
          link: 'link attribute',
          media_id: 'media_id attribute'
        }
      )
    end

    it do
      expect(subject).to eq(
        {
          link: 'link attribute',
          id: 'media_id attribute'
        }
      )
    end
  end
end
