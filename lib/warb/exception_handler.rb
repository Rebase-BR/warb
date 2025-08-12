# frozen_string_literal: true
require "json"

module Warb
  class RequestError < StandardError
    attr_reader :status, :code

    def initialize(message, status: nil, code: nil)
      @status = status
      @code   = code
      super(message)
    end
  end

  class BadRequest < RequestError; end
  class Unauthorized < RequestError; end
  class Forbidden < RequestError; end
  class NotFound < RequestError; end
  class InternalServerError < RequestError; end
  class ServiceUnavailable < RequestError; end

  # custom error classes
  class IntegrityError < Forbidden; end
  class InvalidBusinessNumber < BadRequest; end

  HTTP_ERRORS = {
    "400": BadRequest,
    "401": Unauthorized,
    "403": Forbidden,
    "404": NotFound,
    "500": InternalServerError,
    "503": ServiceUnavailable
  }.freeze

  class ErrorHandler
    def build
      { "400": bad_request }
    end

    private

    def bad_request
      { "33": InvalidBusinessNumber }
    end
  end

  class ResponseErrorHandler
    def initialize(response, config:)
      @response     = response || {}
      @handle_error = config.handle_error
    end

    def handle
      return normalize_success_body(extract_raw_body(@response)) if success_response?(@response)

      response_body = parse_error_body(extract_raw_body(@response))
      begin
        check_for_errors(@response, response_body)
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

    def normalize_success_body(raw)
      return {} if raw.nil? || raw == ""
      if raw.is_a?(String)
        JSON.parse(raw)
      else
        raw
      end
    rescue JSON::ParserError
      {}
    end

    def parse_error_body(raw)
      return {} if raw.nil? || raw == ""
      if raw.is_a?(String)
        JSON.parse(raw)
      elsif raw.is_a?(Hash)
        raw
      else
        {}
      end
    rescue JSON::ParserError
      {}
    end

    def dig_error_field(body, key)
      return nil unless body.is_a?(Hash)
      err = body["error"] || body[:error]
      return nil unless err.is_a?(Hash)
      err[key.to_s] || err[key]
    end

    def check_for_errors(response, response_body)
      status      = extract_status(response)
      error_class = Warb::HTTP_ERRORS[status.to_s.to_sym] || RequestError
      raise_error(error_class, response, response_body)
    end

    def raise_error(error_class, response, response_body)
      message = dig_error_field(response_body, :message) || extract_raw_body(response)
      code    = dig_error_field(response_body, :code)
      raise error_class.new(message, status: extract_status(response), code: code)
    end

    def handle_custom_error(exception)
      status_sym   = exception.status.to_s.to_sym
      error_code   = exception.code.to_s.to_sym
      mapped_error = @handle_error[status_sym]
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
