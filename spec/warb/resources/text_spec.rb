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
  end

  describe "#build_template_named_parameter" do
    it do
      expect(text_resource.build_template_named_parameter("paramater_name")).to eq(
        {
          type: "text",
          text: "content from params",
          parameter_name: "paramater_name"
        }
      )
    end
  end

  describe "#build_template_positional_parameter" do
    it do
      expect(text_resource.build_template_positional_parameter).to eq(
        {
          type: "text",
          text: "content from params"
        }
      )
    end
  end

  describe "#build_template_example_parameter" do
    let(:text_resource) { build :text, content: "Hello {{1}} and {{2}}", examples: ["World", "Friend"] }

    it do
      expect(text_resource.build_template_example_parameter).to eq(
        {
          type: "body",
          text: "Hello {{1}} and {{2}}",
          example: {
            body_text: [["World", "Friend"]]
          }
        }
      )
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
