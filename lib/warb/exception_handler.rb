# frozen_string_literal: true
require "json"

module Warb
  class RequestError < StandardError; end
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
      { 400 => bad_request }
    end

    private

    def bad_request
      { 33 => InvalidBusinessNumber }
    end
  end
end
