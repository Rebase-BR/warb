# frozen_string_literal: true

module Warb
  class Dispatcher
    def initialize(klass, client)
      @klass = klass
      @client = client
    end

    def dispatch(recipient_number, reply_to: nil, **args, &block)
      resource = block_given? ? @klass.new(**args).tap(&block) : @klass.new(**args)

      data     = resource.call(recipient_number, reply_to:)
      response = @client.post("messages", data) || {}

      ResponseErrorHandler.new(response, config: Warb.configuration).handle
    end
  end
end
