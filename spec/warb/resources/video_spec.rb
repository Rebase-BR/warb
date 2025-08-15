# frozen_string_literal: true

RSpec.describe Warb::Resources::Video do
  let(:video_resource) { build :video, media_id: 'media_id', link: 'link', caption: 'caption' }

  describe '#build_header' do
    subject { video_resource.build_header }

    it do
      expect(subject).to eq(
        {
          type: 'video',
          video: {
            id: 'media_id',
            link: 'link'
          }
        }
      )
    end
  end

  describe '#build_payload' do
    subject { video_resource.build_payload }

    it do
      expect(subject).to eq(
        {
          type: 'video',
          video: {
            id: 'media_id',
            link: 'link',
            caption: 'caption'
          }
        }
      )
    end
  end

  context 'priorities' do
    subject { video_resource.build_payload[:video] }

    before do
      allow(video_resource).to receive_messages(
        {
          link: 'link attribute',
          caption: 'caption attribute',
          media_id: 'media_id attribute'
        }
      )
    end

    it do
      expect(subject).to eq(
        {
          id: 'media_id attribute',
          link: 'link attribute',
          caption: 'caption attribute'
        }
      )
    end
  end
end
