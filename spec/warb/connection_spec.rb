# frozen_string_literal: true

require "json"

RSpec.describe Warb::Connection do
  let(:client) do
    instance_double(
      Warb::Client,
      access_token: "token-123",
      adapter: :net_http,
      sender_id: "SID123",
      business_id: "BIZ999"
    )
  end

  subject(:connection) { described_class.new(client) }

  describe "#send_request" do
    let(:faraday_response) { instance_double("Faraday::Response", status: 200, body: { "ok" => true }, headers: {}) }

    before do
      allow_any_instance_of(Faraday::Connection).to receive(:post).and_return(faraday_response)
      allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(faraday_response)
      allow_any_instance_of(Faraday::Connection).to receive(:put).and_return(faraday_response)
      allow_any_instance_of(Faraday::Connection).to receive(:delete).and_return(faraday_response)
    end

    context "success path" do
      it "calls Faraday with :sender_id prefix by default and returns the Faraday response" do
        expect_any_instance_of(Faraday::Connection)
          .to receive(:post).with("SID123/messages", {}, {}).and_return(faraday_response)

        resp = connection.send_request(http_method: "post", endpoint: "messages", data: {}, headers: {})
        expect(resp).to be faraday_response
      end

      it "uses :business_id when endpoint_prefix is :business_id" do
        expect_any_instance_of(Faraday::Connection)
          .to receive(:get).with("BIZ999/message_templates", {}, {}).and_return(faraday_response)

        connection.send_request(http_method: "get", endpoint: "message_templates", endpoint_prefix: :business_id)
      end

      it "uses raw endpoint when endpoint_prefix is nil" do
        expect_any_instance_of(Faraday::Connection)
          .to receive(:put).with("custom/path", { a: 1 }, { "X" => "1" }).and_return(faraday_response)

        connection.send_request(http_method: "put", endpoint: "custom/path", endpoint_prefix: nil, data: { a: 1 }, headers: { "X" => "1" })
      end
    end

    context "error path (Faraday::ClientError -> Warb::RequestError)" do
      it "parses JSON string body and raises Warb::RequestError with message/status/code" do
        error_body = { error: { message: "JSON", code: 123123 } }
        faraday_error = Faraday::ClientError.new("boom", { status: 400, body: error_body })

        allow_any_instance_of(Faraday::Connection)
          .to receive(:post).and_raise(faraday_error)

        expect {
          connection.send_request(http_method: "post", endpoint: "messages")
        }.to raise_error(Warb::RequestError) { |e|
          expect(e.status).to eq 400
          expect(e.code).to eq 123123
          expect(e.message).to eq "JSON"
        }
      end

      it "uses hash body directly and raises Warb::RequestError with message/status/code" do
        error_body = { error: { message: "HASH", code: 33 } }
        faraday_error = Faraday::ClientError.new("boom", { status: 400, body: error_body })

        allow_any_instance_of(Faraday::Connection)
          .to receive(:delete).and_raise(faraday_error)

        expect {
          connection.send_request(http_method: "delete", endpoint: "media/123", endpoint_prefix: nil)
        }.to raise_error(Warb::RequestError) { |e|
          expect(e.status).to eq 400
          expect(e.code).to eq 33
          expect(e.message).to eq "HASH"
        }
      end

      it "handles missing response gracefully (e.response == nil)" do
        faraday_error = Faraday::ClientError.new("boom", nil)

        allow_any_instance_of(Faraday::Connection)
          .to receive(:get).and_raise(faraday_error)

        expect {
          connection.send_request(http_method: "get", endpoint: "messages")
        }.to raise_error(Warb::RequestError) { |e|
          expect(e.status).to be_nil
          expect(e.code).to be_nil
          expect(e.message).to eq("Warb::RequestError")
        }
      end
    end
  end
end
