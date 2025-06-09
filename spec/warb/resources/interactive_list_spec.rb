# frozen_string_literal: true

RSpec.describe Warb::Resources::InteractiveList do
  let(:header) { build(:text, content: "Header").build_header }
  let(:action) { build(:interactive_list_action) }
  let(:interactive_list) { build(:interactive_list, header: header, action: action, body: "Body", footer: "Footer") }

  describe "#build_header" do
    it do
      expect { interactive_list.build_header }.to raise_error NotImplementedError
    end
  end

  describe "#build_payload" do
    subject { interactive_list.build_payload }

    it do
      is_expected.to eq(
        {
          type: "interactive",
          interactive: {
            type: "list",
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
        interactive_list.header = {}

        expect { interactive_list.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              header: :cannot_be_empty
            }
          )
        end
      end

      it do
        interactive_list.header = { text: "Text" }

        expect { interactive_list.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              header_type: :required
            }
          )
        end
      end

      it do
        interactive_list.header = { type: "text", text: nil }

        expect { interactive_list.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              header_text: :required
            }
          )
        end
      end

      it do
        interactive_list.header = { type: "text", text: "#" * 61 }

        expect { interactive_list.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              header_text: :no_longer_than_60_characters
            }
          )
        end
      end

      it do
        interactive_list.header = { type: "image" }

        expect { interactive_list.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              header_type: :invalid_value
            }
          )
        end
      end

      it do
        interactive_list.header = { type: "video" }

        expect { interactive_list.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              header_type: :invalid_value
            }
          )
        end
      end

      it do
        interactive_list.header = { type: "document" }

        expect { interactive_list.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              header_type: :invalid_value
            }
          )
        end
      end

      it do
        interactive_list.header = { type: "unknown type" }

        expect { interactive_list.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              header_type: :invalid_value
            }
          )
        end
      end

      it do
        interactive_list.body = nil

        expect { interactive_list.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              body: :required
            }
          )
        end
      end

      it do
        interactive_list.body = "#" * 4097

        expect { interactive_list.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              body: :no_longer_than_4096_characters
            }
          )
        end
      end

      it do
        interactive_list.footer = "#" * 61

        expect { interactive_list.build_payload }.to raise_error(Warb::Error) do |error|
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
      it { expect { subject.set_image_header }.to raise_error NotImplementedError }
    end

    describe "#set_video_header" do
      it { expect { subject.set_video_header }.to raise_error NotImplementedError }
    end

    describe "#set_document_header" do
      it { expect { subject.set_document_header }.to raise_error NotImplementedError }
    end
  end

  describe "#build_action" do
    context "returned value" do
      it do
        action = interactive_list.build_action
        expect(action).to be interactive_list.action
        expect(action).to be_a Warb::Components::ListAction
      end
    end

    context "returned block instance" do
      it do
        interactive_list.build_action do |action|
          expect(action).to be interactive_list.action
          expect(action).to be_a Warb::Components::ListAction
        end
      end
    end
  end
end
