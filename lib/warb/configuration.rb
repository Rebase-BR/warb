# frozen_string_literal: true

module Warb
  class Configuration
    attr_accessor :access_token, :sender_id, :business_id, :adapter, :logger, :custom_errors

    def initialize(access_token: nil, sender_id: nil, business_id: nil, adapter: nil, logger: nil)
      @access_token = access_token
      @sender_id = sender_id
      @business_id = business_id
      @adapter = adapter || Faraday.default_adapter
      @logger = logger || Logger.new($stdout)
      @custom_errors = CustomErrors.new.build
    end
  end
end
