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
end
