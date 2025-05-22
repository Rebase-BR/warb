# frozen_string_literal: true

require "faraday"
require "faraday/multipart"
require_relative "warb/version"
require_relative "warb/client"
require_relative "warb/media"
require_relative "warb/messages"
require_relative "warb/interactive_messages"
require_relative "warb/location_messages"
require_relative "warb/utils"

module Warb
  MESSAGING_PRODUCT = "whatsapp"

  class Error < StandardError; end
  # Your code goes here...

  class << self
    def logger
      @logger ||= Logger.new($stdout)
    end

    def configuration
      @configuration ||= {}
    end

    def setup(sender_id:, business_id:, access_token:, logger: nil)
      @logger ||= logger
      @configuration ||= { sender_id:, business_id:, access_token: }

      yield(@configuration) if block_given?
    end
  end
end
