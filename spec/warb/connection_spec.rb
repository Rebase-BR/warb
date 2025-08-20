# frozen_string_literal: true

require 'json'

RSpec.describe Warb::Connection do
  subject(:connection) { described_class.new(client) }

  let(:client) do
    instance_double(
      Warb::Client,
      access_token: 'token-123',
      adapter: :net_http,
      sender_id: 'SID123',
      business_id: 'BIZ999'
    )
  end

  describe '#send_request' do
    def faraday_response(status:, body:, success:)
      instance_double(Faraday::Response, status: status, body: body, headers: {}, success?: success)
    end

    context 'success path' do
      it 'returns a Warb::Response when response.success? is true (default sender_id prefix)' do
        f = faraday_response(status: 200, body: {
                               'contacts' => [{ 'input' => '+5511', 'wa_id' => '5511' }],
                               'messages' => [{ 'id' => 'mid-123' }]
                             }, success: true)

        expect_any_instance_of(Faraday::Connection)
          .to receive(:send).with('post', 'SID123/messages', {}, {}).and_return(f)

        resp = connection.send_request(http_method: 'post', endpoint: 'messages', data: {}, headers: {})
        expect(resp).to be_a(Warb::Response)
        expect(resp.input).to eq('+5511')
        expect(resp.wa_id).to eq('5511')
        expect(resp.message_id).to eq('mid-123')
        expect(resp.body).to be_a(Hash)
      end

      it 'uses :business_id prefix when endpoint_prefix is :business_id' do
        f = faraday_response(status: 200, body: { 'ok' => true }, success: true)

        expect_any_instance_of(Faraday::Connection)
          .to receive(:send).with('get', 'BIZ999/message_templates', {}, {}).and_return(f)

        resp = connection.send_request(http_method: 'get', endpoint: 'message_templates', endpoint_prefix: :business_id)
        expect(resp).to be_a(Warb::Response)
        expect(resp.body).to eq({ 'ok' => true })
      end

      it 'uses raw endpoint when endpoint_prefix is nil' do
        f = faraday_response(status: 200, body: { 'ok' => true }, success: true)

        expect_any_instance_of(Faraday::Connection)
          .to receive(:send).with('put', 'custom/path', { a: 1 }, { 'X' => '1' }).and_return(f)

        resp = connection.send_request(
          http_method: 'put',
          endpoint: 'custom/path',
          endpoint_prefix: nil,
          data: { a: 1 },
          headers: { 'X' => '1' }
        )
        expect(resp).to be_a(Warb::Response)
        expect(resp.body).to eq({ 'ok' => true })
      end
    end

    context 'http error path (success? == false -> ResponseErrorHandler handles)' do
      it 'raises a mapped custom error (InvalidBusinessNumber) on 400 with code 33' do
        body = { 'error' => { 'message' => 'Invalid business', 'code' => 33,
                              'error_data' => { 'details' => 'details here' } } }
        f = faraday_response(status: 400, body: body, success: false)

        expect_any_instance_of(Faraday::Connection)
          .to receive(:send).with('post', 'SID123/messages', {}, {}).and_return(f)

        expect do
          connection.send_request(http_method: 'post', endpoint: 'messages')
        end.to raise_error(Warb::InvalidBusinessNumber, /details here|Invalid business/)
      end

      it 'falls back to HTTP error class mapping (e.g., BadRequest) when there is no custom code mapping' do
        body = { 'error' => { 'message' => 'Oops generic', 'code' => 999 } }
        f = faraday_response(status: 400, body: body, success: false)

        expect_any_instance_of(Faraday::Connection)
          .to receive(:send).with('post', 'SID123/messages', {}, {}).and_return(f)

        expect do
          connection.send_request(http_method: 'post', endpoint: 'messages')
        end.to raise_error(Warb::BadRequest, /Oops generic|HTTP 400/)
      end

      it 'falls back to Warb::RequestError if status is not mapped at all' do
        body = { 'error' => { 'message' => 'weird', 'code' => 1 } }
        f = faraday_response(status: 418, body: body, success: false)

        expect_any_instance_of(Faraday::Connection)
          .to receive(:send).with('get', 'SID123/messages', {}, {}).and_return(f)

        expect do
          connection.send_request(http_method: 'get', endpoint: 'messages')
        end.to raise_error(Warb::RequestError, /weird|HTTP 418/)
      end
    end

    context 'faraday error path (Faraday::Error rescue)' do
      it 'raises Warb::RequestError with the error body when available' do
        error_body = { error: { message: 'From Faraday body', code: 123 } }
        faraday_error = Faraday::ClientError.new('boom', { status: 400, body: error_body })

        expect_any_instance_of(Faraday::Connection)
          .to receive(:send).and_raise(faraday_error)

        expect do
          connection.send_request(http_method: 'post', endpoint: 'messages')
        end.to raise_error(Warb::RequestError, /From Faraday body/)
      end

      it 'raises Warb::RequestError with the exception message when there is no response' do
        faraday_error = Faraday::ClientError.new('boom', nil)

        expect_any_instance_of(Faraday::Connection)
          .to receive(:send).and_raise(faraday_error)

        expect do
          connection.send_request(http_method: 'get', endpoint: 'messages')
        end.to raise_error(Warb::RequestError, /boom/)
      end
    end
  end
end
