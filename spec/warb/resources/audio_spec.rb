# frozen_string_literal: true

RSpec.describe Warb::Resources::Audio do
  let(:audio_resource) { build :audio, media_id: 'media_id', link: 'link' }

  describe '#build_header' do
    it do
      expect { audio_resource.build_header }.to raise_error NotImplementedError
    end
  end

  describe '#build_payload' do
    subject { audio_resource.build_payload }

    it do
      expect(subject).to eq(
        {
          type: 'audio',
          audio: {
            id: 'media_id',
            link: 'link'
          }
        }
      )
    end
  end

  context 'priorities' do
    subject { audio_resource.build_payload[:audio] }

    before do
      allow(audio_resource).to receive_messages(
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
