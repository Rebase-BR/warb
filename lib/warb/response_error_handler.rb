module Warb
  class ResponseErrorHandler
    def initialize(body, status)
      @body   = body
      @status = status
    end

    def handle
      raise Warb::RequestError.new('invalid body') if @body.nil?

      code     = @body.dig("error", "code")
      message  = @body.dig("error", "message")
      details  = @body.dig("error", "error_data", "details")

      custom_class = Warb.configuration.custom_errors[@status]&.dig(code)
      http_class   = Warb::HTTP_ERRORS[@status]
      error_class  = custom_class || http_class || Warb::RequestError

      Warb.configuration.logger.error(message.to_s)

      final_message = details || message || "HTTP #{@status}"
      raise error_class, final_message
    end
  end
end
