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
