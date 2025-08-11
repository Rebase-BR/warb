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
      {
        "400": bad_request,
      }
    end

    private

    def bad_request
      { "33": InvalidBusinessNumber }
    end
  end
end
