# frozen_string_literal: true

require "faraday"
require "faraday/multipart"
require_relative "warb/version"
require_relative "warb/configuration"
require_relative "warb/dispatcher_concern"
require_relative "warb/client"
require_relative "warb/resources/resource"
require_relative "warb/resources/text"
require_relative "warb/resources/image"
require_relative "warb/resources/video"
require_relative "warb/resources/sticker"
require_relative "warb/resources/audio"
require_relative "warb/resources/document"
require_relative "warb/resources/location"
require_relative "warb/resources/reaction"
require_relative "warb/resources/location_request"
require_relative "warb/resources/interactive_reply_button"
require_relative "warb/resources/interactive_list"
require_relative "warb/resources/interactive_call_to_action_url"
require_relative "warb/resources/contact"
require_relative "warb/resources/flow"
require_relative "warb/dispatcher"
require_relative "warb/media_dispatcher"
require_relative "warb/indicator_dispatcher"
require_relative "warb/utils"
require_relative "warb/components/action"

module Warb
  MESSAGING_PRODUCT = "whatsapp"
  RECIPIENT_TYPE = "individual"

  class Error < StandardError; end
  # Your code goes here...

  class << self
    include DispatcherConcern

    def new(**args)
      Client.new(**args)
    end

    def client
      @client ||= Client.new(configuration)
    end

    def configuration
      @configuration ||= Configuration.new
    end

    def setup
      yield(configuration)

      client
    end
  end
end
