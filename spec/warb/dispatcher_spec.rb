# frozen_string_literal: true

RSpec.describe Warb::Dispatcher do
  describe "#dispatch" do
    let(:client) { double("Client", post: { status: 200, body: {} }) }
    let(:resource) { double("CustomResource", call: {}) }

    before { class_double("CustomResource", new: resource).as_stubbed_const }

    subject { described_class.new CustomResource, client }

    context "method chain call" do
      it do
        expect(CustomResource).to receive(:new)
        expect(client).to receive(:post).with("messages", {}).and_return({ status: 200, body: {} })
        expect(resource).to receive(:call)

        subject.dispatch("recipient_number")
      end
    end

    context "block call" do
      it do
        expect(CustomResource).to receive(:new).with(attr: "value")
        expect(resource).to receive(:call)
        expect(client).to receive(:post).with("messages", {}).and_return({ status: 200, body: {} })

        subject.dispatch("recipient_number", attr: "value") do |resource_instance|
          expect(resource_instance).to respond_to :call
        end
      end
    end

    context "error handling" do
      let(:resource) { double("CustomResource", call: {}) }

      before { class_double("CustomResource", new: resource).as_stubbed_const }

      subject { described_class.new CustomResource, client }

      context "400 without custom mapping" do
        let(:client) { double("Client", post: { status: 400, body: { error: { message: "Oops", code: 123123 } } }) }

        it "raises BadRequest" do
          expect {
            subject.dispatch("recipient_number")
          }.to raise_error(Warb::BadRequest) { |e|
            expect(e.status).to eq 400
            expect(e.code).to eq 123123
            expect(e.message).to eq "Oops"
          }
        end
      end

      context "400 with custom mapping" do
        let(:client) { double("Client", post: { status: 400, body: { error: { message: "Invalid business", code: 33 } } }) }
        let!(:original_handler) { Warb.configuration.handle_error }

        before do
          Warb.configuration.handle_error = Warb::ErrorHandler.new.build
        end

        after do
          Warb.configuration.handle_error = original_handler
        end

        it "reclassifies to InvalidBusinessNumber" do
          expect {
            subject.dispatch("recipient_number")
          }.to raise_error(Warb::InvalidBusinessNumber) { |e|
            expect(e.status).to eq 400
            expect(e.code).to eq 33
            expect(e.message).to eq "Invalid business"
          }
        end
      end

      context "404 not found" do
        let(:client) { double("Client", post: { status: 404, body: { error: { message: "Not found", code: 0 } } }) }

        it "raises NotFound" do
          expect {
            subject.dispatch("recipient_number")
          }.to raise_error(Warb::NotFound) { |e|
            expect(e.status).to eq 404
            expect(e.code).to eq 0
            expect(e.message).to eq "Not found"
          }
        end
      end

      context "503 service unavailable" do
        let(:client) { double("Client", post: { status: 503, body: { error: { message: "Service unavailable" } } }) }

        it "raises ServiceUnavailable" do
          expect {
            subject.dispatch("recipient_number")
          }.to raise_error(Warb::ServiceUnavailable) { |e|
            expect(e.status).to eq 503
            expect(e.code).to be_nil
            expect(e.message).to eq "Service unavailable"
          }
        end
      end

      context "string JSON body" do
        let(:client) { double("Client", post: { status: 400, body: { error: { message: "Oops", code: 123123 } }.to_json }) }

        it "parses and raises BadRequest" do
          expect { subject.dispatch("recipient_number") }.to raise_error(Warb::BadRequest)
        end
      end

      context "string non-JSON body" do
        let(:client) { double("Client", post: { status: 500, body: "Internal error" }) }

        it "raises InternalServerError with raw message and nil code" do
          expect {
            subject.dispatch("recipient_number")
          }.to raise_error(Warb::InternalServerError) { |e|
            expect(e.status).to eq 500
            expect(e.code).to be_nil
            expect(e.message).to match(/Internal error/)
          }
        end
      end

      context "client.post returns nil" do
        let(:client) { double("Client", post: nil) }

        it "does not raise" do
          expect { subject.dispatch("recipient_number") }.not_to raise_error
        end
      end

      context "status is nil" do
        let(:client) { double("Client", post: { status: nil, body: nil }) }

        it "does not raise" do
          expect { subject.dispatch("recipient_number") }.not_to raise_error
        end
      end
    end
  end
end
