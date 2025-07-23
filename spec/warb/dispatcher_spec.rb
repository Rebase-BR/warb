# frozen_string_literal: true

RSpec.describe Warb::Dispatcher do
  describe "#dispatch" do
    let(:client) { double("Client", post: nil) }
    let(:resource) { double("CustomResource", call: {}) }

    before { class_double("CustomResource", new: resource).as_stubbed_const }

    subject { described_class.new CustomResource, client }

    context "method chain call" do
      it do
        expect(CustomResource).to receive(:new)
        expect(client).to receive(:post).with("messages", {})
        expect(resource).to receive(:call)

        subject.dispatch("recipient_number")
      end
    end

    context "block call" do
      it do
        expect(CustomResource).to receive(:new).with(attr: "value")
        expect(resource).to receive(:call)
        expect(client).to receive(:post).with("messages", {})

        subject.dispatch("recipient_number", attr: "value") do |resource_instance|
          expect(resource_instance).to respond_to :call
        end
      end
    end
  end
end
