module Warb
  class Dispatcher
    def initialize(klass, client)
      @klass = klass
      @client = client
    end

    def dispatch(recipient_number, reply_to: nil, **args, &block)
      resource = block_given? ? @klass.new(**args).tap(&block) : @klass.new(**args)

      data = resource.call(recipient_number, reply_to:)

      @client.post("messages", data)
    end
  end
end
