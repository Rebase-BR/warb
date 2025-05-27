module Warb
  class Configuration
    attr_accessor :access_token, :sender_id, :business_id, :adapter, :logger

    def initialize(access_token: nil, sender_id: nil, business_id: nil, adapter: nil, logger: nil)
      @access_token = access_token
      @sender_id = sender_id
      @business_id = business_id
      @adapter = adapter || Faraday.default_adapter
      @logger = logger || Logger.new($stdout)
    end
  end
end
