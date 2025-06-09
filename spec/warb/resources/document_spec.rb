# frozen_string_literal: true

RSpec.describe Warb::Resources::Document do
  let(:document_resource) do
    build :document, media_id: "media_id", link: "link", caption: "caption",
                     filename: "folder/file.ext"
  end

  describe "#build_header" do
    subject { document_resource.build_header }

    it do
      is_expected.to eq(
        {
          type: "document",
          document: {
            id: "media_id",
            link: "link",
            filename: "folder/file.ext"
          }
        }
      )
    end

    context "errors" do
      subject { described_class.new }

      it do
        expect { subject.build_header }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              link_or_media_id: :required
            }
          )
        end
      end
    end
  end

  describe "#build_payload" do
    subject { document_resource.build_payload }

    it do
      is_expected.to eq(
        {
          type: "document",
          document: {
            id: "media_id",
            link: "link",
            caption: "caption",
            filename: "folder/file.ext"
          }
        }
      )
    end

    context "errors" do
      subject { described_class.new }

      it do
        expect { subject.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              link_or_media_id: :required
            }
          )
        end
      end
    end
  end

  context "priorities" do
    subject { document_resource.build_payload[:document] }

    before do
      allow(document_resource).to receive_messages(
        {
          link: "link attribute",
          caption: "caption attribute",
          media_id: "media_id attribute",
          filename: "filename attribute"
        }
      )
    end

    it do
      is_expected.to eq(
        {
          id: "media_id attribute",
          link: "link attribute",
          caption: "caption attribute",
          filename: "filename attribute"
        }
      )
    end
  end
end
