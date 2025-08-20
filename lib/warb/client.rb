# frozen_string_literal: true

require_relative 'connection'
module Warb
  class Client
    include DispatcherConcern
    extend Forwardable

    attr_reader :access_token, :sender_id, :business_id, :adapter, :logger

    def_delegators :@configuration, :access_token, :sender_id, :business_id, :adapter, :logger

    # rubocop:disable Metrics/ParameterLists
    def initialize(configuration = nil, access_token: nil, sender_id: nil, business_id: nil,
                   adapter: nil, logger: nil)
      @configuration = (configuration || Warb.configuration).dup

      @configuration.access_token = access_token || @configuration.access_token
      @configuration.sender_id = sender_id || @configuration.sender_id
      @configuration.business_id = business_id || @configuration.business_id
      @configuration.adapter = adapter || @configuration.adapter
      @configuration.logger = logger || @configuration.logger
    end
    # rubocop:enable Metrics/ParameterLists

    def get(endpoint, data = {}, **args)
      conn.send_request(http_method: 'get', endpoint: endpoint, data: data, **args)
    end

    def post(endpoint, data = {}, **args)
      conn.send_request(http_method: 'post', endpoint: endpoint, data: data, **args)
    end

    def put(endpoint, data = {}, **args)
      conn.send_request(http_method: 'put', endpoint: endpoint, data: data, **args)
    end

    def delete(endpoint, data = {}, **args)
      conn.send_request(http_method: 'delete', endpoint: endpoint, data: data, **args)
    end

    private

    def conn
      @conn ||= Warb::Connection.new(self)
    end
  end
end
