# frozen_string_literal: true

require_relative "connection"
module Warb
  class Client
    attr_reader :access_token, :sender_id, :business_id, :adapter

    def initialize(access_token: nil, sender_id: nil, business_id: nil, adapter: nil)
      configure(**{ access_token:, sender_id:, business_id:, adapter: }.merge(Warb.configuration))
    end

    def self.setup(**args)
      yield Client.new(**args)
    end

    def get(endpoint, data = {}, **args)
      conn.send_request(http_method: "get", endpoint: endpoint, data: data, **args)
    end

    def post(endpoint, data = {}, **args)
      conn.send_request(http_method: "post", endpoint: endpoint, data: data, **args)
    end

    def put(endpoint, data = {}, **args)
      conn.send_request(http_method: "put", endpoint: endpoint, data: data, **args)
    end

    def delete(endpoint, data = {}, **args)
      conn.send_request(http_method: "delete", endpoint: endpoint, data: data, **args)
    end

    private

    def conn
      @conn ||= Warb::Connection.new(client: self, adapter: @adapter)
    end

    def configure(access_token:, sender_id:, business_id:, adapter:)
      @access_token = access_token
      @sender_id = sender_id
      @business_id = business_id
      @adapter = adapter
    end
  end
end
