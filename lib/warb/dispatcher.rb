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
      response = @client.post("messages", data)
      response[:body] = JSON.parse(response[:body], symbolize_names: true)
      begin
        check_for_errors(response)
      rescue RequestError => exception
        response_status = response[:status].to_s
        error_code = response[:body][:error][:code].to_s
        mapped_error = Warb.configuration.handle_error[response_status.to_sym]

        return raise exception if mapped_error.nil?

        error_class = mapped_error[error_code.to_sym]
        return raise exception if error_class.nil?

        raise error_class, response[:body][:error][:message]
      end
    end

    private

    def check_for_errors(response)
      error_class = HTTP_ERRORS[response[:status].to_s.to_sym]
      return raise_error(RequestError, response) if error_class.nil?

      raise_error(error_class, response)
    end

    def raise_error(error_class, response)
      raise error_class.new(response, status: response[:status], code: response[:body][:error][:code])
    end
  end
end
