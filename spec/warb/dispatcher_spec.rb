# frozen_string_literal: true

RSpec.describe Warb::Dispatcher do
  describe "#dispatch" do
    let(:client)   { double("Client") }
    let(:resource) { double("CustomResource", call: {}) }

    before { stub_const("CustomResource", class_double("CustomResource", new: resource)) }

    subject { described_class.new CustomResource, client }

    context "method chain call" do
      it "instantiates the resource, builds payload and calls client.post" do
        expect(CustomResource).to receive(:new).with(no_args)
        expect(resource).to receive(:call).with("recipient_number", reply_to: nil).and_return({})
        expect(client).to receive(:post).with("messages", {})

        subject.dispatch("recipient_number")
      end
    end

    context "block call" do
      it "yields the resource instance and then calls client.post" do
        expect(CustomResource).to receive(:new).with(attr: "value").and_return(resource)
        expect(resource).to receive(:call).with("recipient_number", reply_to: nil).and_return({})
        expect(client).to receive(:post).with("messages", {})

        subject.dispatch("recipient_number", attr: "value") do |resource_instance|
          expect(resource_instance).to respond_to(:call)
        end
      end
    end

    context "return value" do
      it "returns exactly what client.post returns (e.g., Warb::Response)" do
        warb_response = Warb::Response.new({ "ok" => true })
        allow(resource).to receive(:call).and_return({})
        expect(client).to receive(:post).with("messages", {}).and_return(warb_response)

        result = subject.dispatch("recipient_number")
        expect(result).to be(warb_response)
      end

      it "returns any arbitrary object provided by client.post as-is" do
        token = Object.new
        allow(resource).to receive(:call).and_return({})
        expect(client).to receive(:post).with("messages", {}).and_return(token)

        result = subject.dispatch("recipient_number")
        expect(result).to be(token)
      end
    end
  end
end
