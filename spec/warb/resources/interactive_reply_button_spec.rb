# frozen_string_literal: true

RSpec.describe Warb::Resources::InteractiveReplyButton do
  let(:header) { build(:text, content: "Header").build_header }
  let(:action) { build(:reply_button_action) }
  let(:reply_button) { build(:reply_button, header: header, action: action, body: "Body", footer: "Footer") }

  describe "#build_header" do
    it do
      expect { reply_button.build_header }.to raise_error NotImplementedError
    end
  end

  describe "#build_payload" do
    subject { reply_button.build_payload }

    it do
      is_expected.to eq(
        {
          type: "interactive",
          interactive: {
            type: "button",
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
        reply_button.header = {}

        expect { reply_button.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              header: :cannot_be_empty
            }
          )
        end
      end

      it do
        reply_button.header = { text: "Text" }

        expect { reply_button.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              header_type: :required
            }
          )
        end
      end

      it do
        reply_button.header = { type: "text", text: nil }

        expect { reply_button.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              header_text: :required
            }
          )
        end
      end

      it do
        reply_button.header = { type: "text", text: "#" * 61 }

        expect { reply_button.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              header_text: :no_longer_than_60_characters
            }
          )
        end
      end

      it do
        reply_button.header = { type: "image", image: nil }

        expect { reply_button.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              header_image: :required
            }
          )
        end
      end

      it do
        reply_button.header = { type: "image", image: { link: nil } }

        expect { reply_button.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              header_image_link: :required
            }
          )
        end
      end

      it do
        reply_button.header = { type: "image", image: { link: "not_a_valid_url" } }

        expect { reply_button.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              header_image_link: :invalid_value
            }
          )
        end
      end

      it do
        reply_button.header = { type: "video", video: nil }

        expect { reply_button.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              header_video: :required
            }
          )
        end
      end

      it do
        reply_button.header = { type: "video", video: { link: nil } }

        expect { reply_button.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              header_video_link: :required
            }
          )
        end
      end

      it do
        reply_button.header = { type: "video", video: { link: "not_a_valid_url" } }

        expect { reply_button.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              header_video_link: :invalid_value
            }
          )
        end
      end

      it do
        reply_button.header = { type: "document", document: nil }

        expect { reply_button.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              header_document: :required
            }
          )
        end
      end

      it do
        reply_button.header = { type: "document", document: { link: nil } }

        expect { reply_button.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              header_document_link: :required
            }
          )
        end
      end

      it do
        reply_button.header = { type: "document", document: { link: "not_a_valid_url" } }

        expect { reply_button.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              header_document_link: :invalid_value
            }
          )
        end
      end

      it do
        reply_button.header = { type: "unknown type" }

        expect { reply_button.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              header_type: :invalid_value
            }
          )
        end
      end

      it do
        reply_button.body = nil

        expect { reply_button.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              body: :required
            }
          )
        end
      end

      it do
        reply_button.body = "#" * 4097

        expect { reply_button.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              body: :no_longer_than_4096_characters
            }
          )
        end
      end

      it do
        reply_button.footer = "#" * 61

        expect { reply_button.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              footer: :no_longer_than_60_characters
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

      it do
        expect { subject.set_image_header(media_id: "image_id") }.to change(subject, :header)
          .from(nil).to({ type: "image", image: { link: nil, id: "image_id" } })
      end
    end

    describe "#set_video_header" do
      it do
        expect { subject.set_video_header(link: "link_to_video") }.to change(subject, :header)
          .from(nil).to({ type: "video", video: { link: "link_to_video", id: nil } })
      end

      it do
        expect { subject.set_video_header(media_id: "video_id") }.to change(subject, :header)
          .from(nil).to({ type: "video", video: { link: nil, id: "video_id" } })
      end
    end

    describe "#set_document_header" do
      it do
        expect { subject.set_document_header(link: "link_to_document") }.to change(subject, :header)
          .from(nil).to({ type: "document", document: { link: "link_to_document", id: nil, filename: nil } })
      end

      it do
        expect { subject.set_document_header(media_id: "document_id", filename: "document.pdf") }.to change(
          subject, :header
        ).from(nil).to({ type: "document", document: { link: nil, id: "document_id", filename: "document.pdf" } })
      end
    end
  end

  describe "#build_action" do
    context "returned value" do
      it do
        action = reply_button.build_action
        expect(action).to be reply_button.action
        expect(action).to be_a Warb::Components::ReplyButtonAction
      end
    end

    context "returned block instance" do
      it do
        reply_button.build_action do |action|
          expect(action).to be reply_button.action
          expect(action).to be_a Warb::Components::ReplyButtonAction
        end
      end
    end
  end
end
