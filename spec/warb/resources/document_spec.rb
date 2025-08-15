# frozen_string_literal: true

RSpec.describe Warb::Resources::Document do
  let(:document_resource) do
    build :document, media_id: 'media_id', link: 'link', caption: 'caption',
                     filename: 'folder/file.ext'
  end

  describe '#build_header' do
    subject { document_resource.build_header }

    it do
      expect(subject).to eq(
        {
          type: 'document',
          document: {
            id: 'media_id',
            link: 'link',
            filename: 'folder/file.ext'
          }
        }
      )
    end
  end

  describe '#build_payload' do
    subject { document_resource.build_payload }

    it do
      expect(subject).to eq(
        {
          type: 'document',
          document: {
            id: 'media_id',
            link: 'link',
            caption: 'caption',
            filename: 'folder/file.ext'
          }
        }
      )
    end
  end

  context 'priorities' do
    subject { document_resource.build_payload[:document] }

    before do
      allow(document_resource).to receive_messages(
        {
          link: 'link attribute',
          caption: 'caption attribute',
          media_id: 'media_id attribute',
          filename: 'filename attribute'
        }
      )
    end

    it do
      expect(subject).to eq(
        {
          id: 'media_id attribute',
          link: 'link attribute',
          caption: 'caption attribute',
          filename: 'filename attribute'
        }
      )
    end
  end
end
