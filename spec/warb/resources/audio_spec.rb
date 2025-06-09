# frozen_string_literal: true

RSpec.describe Warb::Resources::Audio do
  let(:audio_resource) { build :audio, media_id: "media_id", link: "link" }

  describe "#build_header" do
    it do
      expect { audio_resource.build_header }.to raise_error NotImplementedError
    end
  end

  describe "#build_payload" do
    subject { audio_resource.build_payload }

    it do
      is_expected.to eq(
        {
          type: "audio",
          audio: {
            id: "media_id",
            link: "link"
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
    subject { audio_resource.build_payload[:audio] }

    before do
      allow(audio_resource).to receive_messages(
        {
          link: "link attribute",
          media_id: "media_id attribute"
        }
      )
    end

    it do
      is_expected.to eq(
        {
          link: "link attribute",
          id: "media_id attribute"
        }
      )
    end
  end
end
