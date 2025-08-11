module Warb
  class Dispatcher
    def initialize(klass, client)
      @klass = klass
      @client = client
    end

    def dispatch(recipient_number, reply_to: nil, **args, &block)
      resource = block_given? ? @klass.new(**args).tap(&block) : @klass.new(**args)

      data = resource.call(recipient_number, reply_to:)
      response = @client.post("messages", data) || {}

      return parse_body(extract_raw_body(response)) if success_response?(response)

      body = parse_body(extract_raw_body(response))

      begin
        check_for_errors(response, body)
      rescue RequestError => exception
        handle_custom_error(exception)
      end
    end

    private

    def extract_status(response)
      response.respond_to?(:status) ? response.status : response[:status]
    end

    def extract_raw_body(response)
      response.respond_to?(:body) ? response.body : response[:body]
    end

    def success_response?(response)
      if response.respond_to?(:success?)
        response.success?
      else
        s = extract_status(response).to_i
        s != 0 && s < 400
      end
    end

    def parse_body(raw)
      return {} if raw.nil? || raw == ""
      if raw.is_a?(String)
        JSON.parse(raw, symbolize_names: true)
      elsif raw.is_a?(Hash)
        symbolize_keys_deep(raw)
      else
        raw
      end
    rescue JSON::ParserError
      {}
    end

    def symbolize_keys_deep(obj)
      case obj
      when Hash
        obj.each_with_object({}) do |(k, v), h|
          key = (k.respond_to?(:to_sym) ? k.to_sym : k)
          h[key] = symbolize_keys_deep(v)
        end
      when Array
        obj.map { |e| symbolize_keys_deep(e) }
      else
        obj
      end
    end

    def check_for_errors(response, response_body)
      status = extract_status(response)
      error_class = Warb::HTTP_ERRORS[status.to_s.to_sym] || RequestError
      raise_error(error_class, response, response_body)
    end

    def raise_error(error_class, response, response_body)
      message = response_body.dig(:error, :message) || extract_raw_body(response)
      code    = response_body.dig(:error, :code)
      raise error_class.new(message, status: extract_status(response), code: code)
    end

    def handle_custom_error(exception)
      status_sym   = exception.status.to_s.to_sym
      error_code   = exception.code.to_s.to_sym
      mapped_error = Warb.configuration.handle_error[status_sym]
      raise exception if mapped_error.nil?

      error_class = mapped_error[error_code]
      raise exception if error_class.nil?

      raise_custom_or_fallback(error_class, exception.message, status: exception.status, code: exception.code)
    end

    def raise_custom_or_fallback(error_class, message, status:, code:)
      begin
        raise error_class.new(message, status: status, code: code)
      rescue ArgumentError, NoMethodError
        decorated = [message, ("status=#{status}" if status), ("code=#{code}" if code)].compact.join(" | ")
        raise error_class, decorated
      end
    end
  end
end
