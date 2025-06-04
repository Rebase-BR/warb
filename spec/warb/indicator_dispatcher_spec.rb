# frozen_string_literal: true

RSpec.describe Warb::IndicatorDispatcher do
  describe "#mark_as_read" do
    let(:client) { Warb.client }
    let(:data) { { messaging_product: "whatsapp", message_id: "message_id", status: "read" } }

    subject { described_class.new client }

    it do
      expect(client).to receive(:post).with("messages", data)

      subject.mark_as_read("message_id")
    end
  end
end
