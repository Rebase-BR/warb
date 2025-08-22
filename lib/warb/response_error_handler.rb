# frozen_string_literal: true

module Warb
  class ResponseErrorHandler
    def initialize(body, status)
      @body   = body
      @status = status
    end

    def handle
      raise Warb::RequestError, 'invalid body' if @body.nil?

      http_class   = Warb::HTTP_ERRORS[@status]
      error_class  = custom_class || http_class || Warb::RequestError
      Warb.configuration.logger.error(message.to_s)

      raise error_class, message_from_error
    end

    private

    def custom_class
      Warb.configuration.custom_errors[@status]&.dig(code)
    end

    def message_from_error
      details ? "(##{code}) #{details}" : message
    end

    def code
      @code ||= @body.dig('error', 'code')
    end

    def message
      @message ||= @body.dig('error', 'message')
    end

    def details
      @details ||= @body.dig('error', 'error_data', 'details')
    end
  end
end
