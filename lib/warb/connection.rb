# frozen_string_literal: true

module Warb
  class Connection
    attr_reader :client, :adapter

    def initialize(client:, adapter:)
      @client = client
      @adapter = adapter || Faraday.default_adapter
    end

    def send_request(http_method:, endpoint:, url: nil, data: {}, headers: {}, multipart: false,
                     endpoint_prefix: :sender_id)
      conn = set_connection(url:, multipart:)
      conn.send(http_method, handle_endpoint(endpoint:, endpoint_prefix:), data, headers)
    rescue StandardError => e
      Warb.logger.error e.inspect
      e.response
    end

    private

    def set_connection(url:, multipart:)
      url ||= "https://graph.facebook.com/v22.0"

      Faraday.new(url) do |conn|
        conn.request(:multipart) if multipart
        conn.request(:url_encoded)
        conn.response(:json)
        conn.headers["Authorization"] = "Bearer #{@client.access_token}" unless @client.access_token.nil?
        conn.adapter(@adapter)
        conn.response :raise_error
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
