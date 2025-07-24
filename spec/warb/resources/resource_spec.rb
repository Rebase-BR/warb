# frozen_string_literal: true

RSpec.describe Warb::Resources::Resource do
  subject { described_class.new }

  describe "#call" do
    context "return value by callng protected common_resource_params" do
      before do
        allow(subject).to receive(:build_payload).and_return({})
        allow(subject).to receive(:common_resource_params).and_call_original
        allow(subject).to receive(:call).and_call_original
      end

      it do
        expect(subject).to receive(:build_payload)

        expect(subject.call("recipient_number")).to eq(
          {
            messaging_product: "whatsapp",
            recipient_type: "individual",
            to: "recipient_number"
          }
        )
      end
    end
  end

  describe "#build_header" do
    it do
      expect { subject.build_header }.to raise_error NotImplementedError
    end
  end

  describe "#build_payload" do
    it do
      expect { subject.build_payload }.to raise_error NotImplementedError
    end
  end

  describe "#build_template_positional_parameter" do
    it do
      expect { subject.build_template_positional_parameter }.to raise_error NotImplementedError
    end
  end

  describe "#build_template_named_parameter" do
    it do
      expect { subject.build_template_named_parameter("paramater_name") }.to raise_error NotImplementedError
    end
  end

  describe "#set_text_header" do
    it do
      expect { subject.set_text_header }.to raise_error NotImplementedError
    end
  end

  describe "#set_image_header" do
    it do
      expect { subject.set_image_header }.to raise_error NotImplementedError
    end
  end

  describe "#set_video_header" do
    it do
      expect { subject.set_video_header }.to raise_error NotImplementedError
    end
  end

  describe "#set_document_header" do
    it do
      expect { subject.set_document_header }.to raise_error NotImplementedError
    end
  end
end
