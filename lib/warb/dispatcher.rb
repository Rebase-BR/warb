module Warb
  HTTP_ERRORS = {
    "400": BadRequest,
    "401": Unauthorized,
    "403": Forbidden,
    "404": NotFound,
    "500": InternalServerError,
    "503": ServiceUnavailable
  }.freeze

  class Dispatcher
    def initialize(klass, client)
      @klass = klass
      @client = client
    end

    def dispatch(recipient_number, reply_to: nil, **args, &block)
      resource = block_given? ? @klass.new(**args).tap(&block) : @klass.new(**args)

      data = resource.call(recipient_number, reply_to:)
      response = @client.post("messages", data) || {}
      status = response[:status].to_i
      return response if status.zero? || status < 400

      body = parse_body(response[:body])

      begin
        check_for_errors(response, body)
      rescue RequestError => exception
        handle_custom_error(exception)
      end
    end

    private

    def parse_body(raw)
      return {} if raw.nil? || raw == ""
      raw.is_a?(String) ? JSON.parse(raw, symbolize_names: true) : raw
    rescue JSON::ParserError
      {}
    end

    def check_for_errors(response, response_body)
      error_class = HTTP_ERRORS[response[:status].to_s.to_sym]
      error_class ||= RequestError
      raise_error(error_class, response, response_body)
    end

    def raise_error(error_class, response, response_body)
      message = response_body.dig(:error, :message) || response[:body]
      code    = response_body.dig(:error, :code)
      raise error_class.new(message, status: response[:status], code: code)
    end

    def handle_custom_error(exception)
      status_sym   = exception.status.to_s.to_sym
      error_code   = exception.code.to_s.to_sym
      mapped_error = Warb.configuration.handle_error[status_sym]

      return raise exception if mapped_error.nil?

      error_class = mapped_error[error_code]
      return raise exception if error_class.nil?

      raise error_class.new(exception.message, status: exception.status, code: exception.code)
    end
  end
end
