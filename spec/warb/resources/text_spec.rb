# frozen_string_literal: true

RSpec.describe Warb::Resources::Text do
  let(:text_resource) do
    build :text, message: "message from params", text: "text from params",
                 content: "content from params", preview_url: false
  end

  describe "#build_header" do
    it do
      expect(text_resource.build_header).to eq(
        {
          type: "text",
          text: "content from params"
        }
      )
    end

    context "errors" do
      subject { build :text, content: nil }

      it do
        expect { subject.build_header }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              text: :required
            }
          )
        end
      end

      it do
        subject.content = "#" * 61

        expect { subject.build_header }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              text: :no_longer_than_60_characters
            }
          )
        end
      end
    end
  end

  describe "#build_payload" do
    it do
      expect(text_resource.build_payload).to eq(
        {
          type: "text",
          text: {
            preview_url: false,
            body: "content from params"
          }
        }
      )
    end

    context "errors" do
      subject { build :text, content: nil }

      it do
        expect { subject.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              text: :required
            }
          )
        end
      end

      it do
        subject.text = "#" * 4097

        expect { subject.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              text: :no_longer_than_4096_characters
            }
          )
        end
      end
    end
  end

  describe "#message_per_priority" do
    subject { text_resource.build_header[:text] }

    context "returns @params[:message]" do
      let(:text_resource) { described_class.new message: "message from params" }

      it { is_expected.to eq "message from params" }
    end

    context "returns @params[:text]" do
      let(:text_resource) { described_class.new message: "message from params", text: "text from params" }

      it { is_expected.to eq "text from params" }
    end

    context "returns @params[:content]" do
      it { is_expected.to eq "content from params" }
    end

    context "returns message attribute" do
      before { text_resource.message = "message attribute" }

      it { is_expected.to eq "message attribute" }
    end

    context "returns text attribute" do
      before do
        text_resource.message = "message attribute"
        text_resource.text = "text attribute"
      end

      it { is_expected.to eq "text attribute" }
    end

    context "returns content attribute" do
      before do
        text_resource.message = "message attribute"
        text_resource.content = "content attribute"
        text_resource.text = "text attribute"
      end

      it { is_expected.to eq "content attribute" }
    end
  end
end
