module Warb
  class RequestError < StandardError
    attr_reader :status, :code

    def initialize(message, status: nil, code: nil)
      @status = status
      @code = code

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

  class ErrorHandler
    def build
      {
        "400": bad_request,
        "401": unauthorized,
        "403": forbidden,
        "404": not_found,
        "500": internal_server_error,
        "503": service_unavailable
      }
    end

    private

    def bad_request
      { "33": InvalidBusinessNumber }
    end

    def unauthorized
    end

    def forbidden
    end

    def not_found
    end

    def internal_server_error
    end

    def service_unavailable
    end
  end
end
