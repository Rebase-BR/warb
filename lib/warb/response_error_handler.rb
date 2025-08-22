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

      raise error_class, message
    end

    private

    def custom_class
      Warb.configuration.custom_errors[@status]&.dig(code)
    end

    def code
      @code ||= @body.dig('error', 'code')
    end

    def message
      @message ||= @body.dig('error', 'message')
    end
  end
end
