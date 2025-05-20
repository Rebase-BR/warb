# frozen_string_literal: true

module Warb
  class Client
    attr_reader :access_token, :sender_id, :headers

    def initialize(access_token:, sender_id:)
      @access_token = access_token
      @sender_id = sender_id
    end

    def conn(url: nil, user_related: true, as_json: true)
      if url.nil?
        url = "https://graph.facebook.com/v22.0"
        url = "#{url}/#{@sender_id}" if user_related
      end

      Faraday.new(url) do |conn|
        conn.headers["Authorization"] = "Bearer #{@access_token}"
        conn.headers["Content-Type"] = "application/json" if as_json

        conn.request :multipart unless as_json
        conn.request :url_encoded unless as_json
      end
    end
  end
end
