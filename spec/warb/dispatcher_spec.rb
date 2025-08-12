# frozen_string_literal: true

RSpec.describe Warb::Dispatcher do
  describe "#dispatch" do
    let(:client)   { double("Client", post: { status: 200, body: {} }) }
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

    context "return value on success" do
      it "returns the parsed body hash when client returns hash" do
        client = double("Client", post: { status: 200, body: { "ok" => true } })
        dispatcher = described_class.new CustomResource, client
        expect(dispatcher.dispatch("recipient_number")).to eq({ "ok" => true })
      end

      it "returns the parsed body when client returns Faraday-like response" do
        faraday_like = double("Faraday::Response", status: 200, body: { "ok" => true }, success?: true)
        client = double("Client", post: faraday_like)
        dispatcher = described_class.new CustomResource, client
        expect(dispatcher.dispatch("recipient_number")).to eq({ "ok" => true })
      end

      it "parses string JSON and returns string-keyed hash" do
        client = double("Client", post: { status: 200, body: '{"ok":true,"arr":[{"x":1}]}' })
        dispatcher = described_class.new CustomResource, client
        expect(dispatcher.dispatch("recipient_number")).to eq({ "ok" => true, "arr" => [{ "x" => 1 }] })
      end

      it "returns {} for invalid JSON string bodies" do
        client = double("Client", post: { status: 200, body: "<html>oops</html>" })
        dispatcher = described_class.new CustomResource, client
        expect(dispatcher.dispatch("recipient_number")).to eq({})
      end
    end

    context "HTTP mapping statuses" do
      it "raises Unauthorized on 401" do
        client = double("Client", post: { status: 401, body: { error: { message: "unauth" } } })
        dispatcher = described_class.new CustomResource, client
        expect { dispatcher.dispatch("recipient_number") }.to raise_error(Warb::Unauthorized)
      end

      it "raises Forbidden on 403" do
        client = double("Client", post: { status: 403, body: { error: { message: "forbidden" } } })
        dispatcher = described_class.new CustomResource, client
        expect { dispatcher.dispatch("recipient_number") }.to raise_error(Warb::Forbidden)
      end

      it "raises NotFound on 404" do
        client = double("Client", post: { status: 404, body: { error: { message: "Not found", code: 0 } } })
        dispatcher = described_class.new CustomResource, client
        expect { dispatcher.dispatch("recipient_number") }.to raise_error(Warb::NotFound) { |e|
          expect(e.status).to eq 404
          expect(e.code).to eq 0
          expect(e.message).to eq "Not found"
        }
      end

      it "raises InternalServerError on 500" do
        client = double("Client", post: { status: 500, body: { error: { message: "boom" } } })
        dispatcher = described_class.new CustomResource, client
        expect { dispatcher.dispatch("recipient_number") }.to raise_error(Warb::InternalServerError)
      end

      it "raises ServiceUnavailable on 503" do
        client = double("Client", post: { status: 503, body: { error: { message: "Service unavailable" } } })
        dispatcher = described_class.new CustomResource, client
        expect { dispatcher.dispatch("recipient_number") }.to raise_error(Warb::ServiceUnavailable) { |e|
          expect(e.status).to eq 503
          expect(e.code).to be_nil
          expect(e.message).to eq "Service unavailable"
        }
      end
    end

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

      before { Warb.configuration.handle_error = Warb::ErrorHandler.new.build }
      after  { Warb.configuration.handle_error = original_handler }

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

    context "error payload shapes" do
      it "parses string JSON error and raises BadRequest" do
        client = double("Client", post: { status: 400, body: { error: { message: "Oops", code: 123123 } }.to_json })
        dispatcher = described_class.new CustomResource, client
        expect { dispatcher.dispatch("recipient_number") }.to raise_error(Warb::BadRequest)
      end

      it "uses raw string body on non-JSON error body" do
        client = double("Client", post: { status: 500, body: "Internal error" })
        dispatcher = described_class.new CustomResource, client
        expect {
          dispatcher.dispatch("recipient_number")
        }.to raise_error(Warb::InternalServerError) { |e|
          expect(e.status).to eq 500
          expect(e.code).to be_nil
          expect(e.message).to match(/Internal error/)
        }
      end
    end

    context "invalid/edge responses" do
      it "raises RequestError when client.post returns nil" do
        client = double("Client", post: nil)
        dispatcher = described_class.new CustomResource, client
        expect { dispatcher.dispatch("recipient_number") }
          .to raise_error(Warb::RequestError)
      end

      it "raises RequestError when status is nil" do
        client = double("Client", post: { status: nil, body: nil })
        dispatcher = described_class.new CustomResource, client
        expect { dispatcher.dispatch("recipient_number") }
          .to raise_error(Warb::RequestError) { |e|
            expect(e.status).to be_nil
            expect(e.code).to be_nil
            expect(e.message).to eq("Warb::RequestError")
          }
      end
    end

    context "custom mapping not present" do
      it "re-raises original RequestError when no status mapping" do
        client = double("Client", post: { status: 400, body: { error: { message: "oops", code: 999 } } })
        original = Warb.configuration.handle_error
        begin
          Warb.configuration.handle_error = {}
          dispatcher = described_class.new CustomResource, client
          expect { dispatcher.dispatch("recipient_number") }.to raise_error(Warb::BadRequest)
        ensure
          Warb.configuration.handle_error = original
        end
      end
    end

    context "custom mapping missing code under status" do
      it "re-raises original RequestError when code is not mapped" do
        client = double("Client", post: { status: 400, body: { error: { message: "oops", code: 777 } } })
        original = Warb.configuration.handle_error
        begin
          Warb.configuration.handle_error = { :"400" => { :"33" => Warb::InvalidBusinessNumber } }
          dispatcher = described_class.new CustomResource, client
          expect { dispatcher.dispatch("recipient_number") }.to raise_error(Warb::BadRequest)
        ensure
          Warb.configuration.handle_error = original
        end
      end
    end

    context "custom error fallback when class doesn't accept status/code" do
      class SimpleCustomError < StandardError; end

      it "falls back to standard raise with decorated message" do
        client = double("Client", post: { status: 400, body: { error: { message: "bad", code: 33 } } })
        original = Warb.configuration.handle_error
        begin
          Warb.configuration.handle_error = { :"400" => { :"33" => SimpleCustomError } }
          dispatcher = described_class.new CustomResource, client
          expect { dispatcher.dispatch("recipient_number") }
            .to raise_error(SimpleCustomError, /bad.*status=400.*code=33/)
        ensure
          Warb.configuration.handle_error = original
        end
      end
    end
  end
end
