# frozen_string_literal: true

require 'faraday'
require 'faraday/multipart'
require_relative 'warb/version'
require_relative 'warb/language'
require_relative 'warb/configuration'
require_relative 'warb/dispatcher_concern'
require_relative 'warb/client'
require_relative 'warb/errors'
require_relative 'warb/response_error_handler'
require_relative 'warb/response'
require_relative 'warb/resources/resource'
require_relative 'warb/resources/text'
require_relative 'warb/resources/image'
require_relative 'warb/resources/video'
require_relative 'warb/resources/sticker'
require_relative 'warb/resources/audio'
require_relative 'warb/resources/document'
require_relative 'warb/resources/location'
require_relative 'warb/resources/reaction'
require_relative 'warb/resources/location_request'
require_relative 'warb/resources/interactive_reply_button'
require_relative 'warb/resources/interactive_list'
require_relative 'warb/resources/interactive_call_to_action_url'
require_relative 'warb/resources/contact'
require_relative 'warb/resources/template'
require_relative 'warb/resources/currency'
require_relative 'warb/resources/date_time'
require_relative 'warb/resources/flow'
require_relative 'warb/dispatcher'
require_relative 'warb/media_dispatcher'
require_relative 'warb/template_dispatcher'
require_relative 'warb/indicator_dispatcher'
require_relative 'warb/utils'
require_relative 'warb/components/component'
require_relative 'warb/components/button'
require_relative 'warb/components/quick_reply_button'
require_relative 'warb/components/url_button'
require_relative 'warb/components/copy_code_button'
require_relative 'warb/components/voice_call_button'
require_relative 'warb/components/action'

module Warb
  MESSAGING_PRODUCT = 'whatsapp'
  RECIPIENT_TYPE = 'individual'
  HTTP_ERRORS = {
    400 => BadRequest,
    401 => Unauthorized,
    403 => Forbidden,
    404 => NotFound,
    500 => InternalServerError,
    503 => ServiceUnavailable
  }.freeze

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
