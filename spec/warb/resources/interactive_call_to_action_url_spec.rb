# frozen_string_literal: true

RSpec.describe Warb::Resources::InteractiveCallToActionUrl do
  let(:header) { build(:text, content: "Header").build_header }
  let(:action) { build(:cta_action) }
  let(:cta) { build(:cta, header: header, action: action, body: "Body", footer: "Footer") }

  describe "#build_header" do
    it do
      expect { cta.build_header }.to raise_error NotImplementedError
    end
  end

  describe "#build_payload" do
    subject { cta.build_payload }

    it do
      is_expected.to eq(
        {
          type: "interactive",
          interactive: {
            type: "cta_url",
            header: {
              type: "text",
              text: "Header"
            },
            body: {
              text: "Body"
            },
            footer: {
              text: "Footer"
            },
            action: action.to_h
          }
        }
      )
    end

    context "errors" do
      it do
        cta.header = {}

        expect { cta.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              header: :cannot_be_empty
            }
          )
        end
      end

      it do
        cta.header = { text: "Text" }

        expect { cta.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              header_type: :required
            }
          )
        end
      end

      it do
        cta.header = { type: "text", text: nil }

        expect { cta.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              header_text: :required
            }
          )
        end
      end

      it do
        cta.header = { type: "text", text: "#" * 61 }

        expect { cta.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              header_text: :no_longer_than_60_characters
            }
          )
        end
      end

      it do
        cta.header = { type: "image", image: nil }

        expect { cta.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              header_image: :required
            }
          )
        end
      end

      it do
        cta.header = { type: "image", image: { link: nil } }

        expect { cta.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              header_image_link: :required
            }
          )
        end
      end

      it do
        cta.header = { type: "image", image: { link: "not_a_valid_url" } }

        expect { cta.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              header_image_link: :invalid_value
            }
          )
        end
      end

      it do
        cta.header = { type: "video", video: nil }

        expect { cta.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              header_video: :required
            }
          )
        end
      end

      it do
        cta.header = { type: "video", video: { link: nil } }

        expect { cta.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              header_video_link: :required
            }
          )
        end
      end

      it do
        cta.header = { type: "video", video: { link: "not_a_valid_url" } }

        expect { cta.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              header_video_link: :invalid_value
            }
          )
        end
      end

      it do
        cta.header = { type: "document", document: nil }

        expect { cta.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              header_document: :required
            }
          )
        end
      end

      it do
        cta.header = { type: "document", document: { link: nil } }

        expect { cta.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              header_document_link: :required
            }
          )
        end
      end

      it do
        cta.header = { type: "document", document: { link: "not_a_valid_url" } }

        expect { cta.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              header_document_link: :invalid_value
            }
          )
        end
      end

      it do
        cta.header = { type: "unknown type" }

        expect { cta.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              header_type: :invalid_value
            }
          )
        end
      end
    end
  end

  context "headers" do
    subject { described_class.new }

    describe "#set_text_header" do
      it do
        expect { subject.set_text_header("Header") }.to change(subject, :header)
          .from(nil).to({ type: "text", text: "Header" })
      end
    end

    describe "#set_image_header" do
      it do
        expect { subject.set_image_header(link: "link_to_image") }.to change(subject, :header)
          .from(nil).to({ type: "image", image: { link: "link_to_image", id: nil } })
      end
    end

    describe "#set_video_header" do
      it do
        expect { subject.set_video_header(link: "link_to_video") }.to change(subject, :header)
          .from(nil).to({ type: "video", video: { link: "link_to_video", id: nil } })
      end
    end

    describe "#set_document_header" do
      it do
        expect { subject.set_document_header(link: "link_to_document", filename: "document.pdf") }.to change(subject, :header)
          .from(nil).to({ type: "document", document: { link: "link_to_document", id: nil, filename: "document.pdf" } })
      end
    end
  end

  describe "#build_action" do
    context "returned value" do
      it do
        action = cta.build_action
        expect(action).to be cta.action
        expect(action).to be_a Warb::Components::CTAAction
      end
    end

    context "returned block instance" do
      it do
        cta.build_action do |action|
          expect(action).to be cta.action
          expect(action).to be_a Warb::Components::CTAAction
        end
      end
    end
  end
end
