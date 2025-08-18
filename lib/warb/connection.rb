# frozen_string_literal: true

module Warb
  class Connection
    attr_reader :client

    def initialize(client)
      @client = client
    end

    # rubocop:disable Metrics/ParameterLists
    def send_request(http_method:, endpoint:, url: nil, data: {}, headers: {}, multipart: false,
                     endpoint_prefix: :sender_id)
      conn = set_connection(url:, multipart:)
      response = conn.send(http_method, handle_endpoint(endpoint:, endpoint_prefix:), data, headers)
      if response.success?
        Warb::Response.new(response.body)
      else
        Warb::ResponseErrorHandler.new(response.body, response.status).handle
      end
    rescue Faraday::Error => e
      msg = e.response_body || e.message
      raise RequestError, msg
    end
    # rubocop:enable Metrics/ParameterLists

    private

    def set_connection(url:, multipart:)
      url ||= 'https://graph.facebook.com/v22.0'

      Faraday.new(url) do |conn|
        conn.request(:multipart) if multipart
        conn.request(:url_encoded) if multipart
        conn.request(:json)
        conn.response(:json)
        conn.headers['Authorization'] = "Bearer #{@client.access_token}" unless @client.access_token.nil?
        conn.adapter(@client.adapter)
      end
    end

    def handle_endpoint(endpoint:, endpoint_prefix:)
      case endpoint_prefix
      when :sender_id
        "#{@client.sender_id}/#{endpoint}"
      when :business_id
        "#{@client.business_id}/#{endpoint}"
      else
        endpoint
      end
    end
  end
end
