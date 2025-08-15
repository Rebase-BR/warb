# frozen_string_literal: true

RSpec.describe Warb::Resources::Image do
  let(:image_resource) { build :image, media_id: 'media_id', link: 'link', caption: 'caption' }

  describe '#build_header' do
    subject { image_resource.build_header }

    it do
      expect(subject).to eq(
        {
          type: 'image',
          image: {
            id: 'media_id',
            link: 'link'
          }
        }
      )
    end
  end

  describe '#build_payload' do
    subject { image_resource.build_payload }

    it do
      expect(subject).to eq(
        {
          type: 'image',
          image: {
            id: 'media_id',
            link: 'link',
            caption: 'caption'
          }
        }
      )
    end
  end

  context 'priorities' do
    subject { image_resource.build_payload[:image] }

    before do
      allow(image_resource).to receive_messages(
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
