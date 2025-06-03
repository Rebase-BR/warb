module Warb
  class Dispatcher
    def initialize(klass, client)
      @klass = klass
      @client = client
    end

    def dispatch(recipient_number, **args, &block)
      resource = block_given? ? @klass.new.tap(&block) : @klass.new(**args)

      data = resource.call(recipient_number)

      @client.post("messages", data)
    end
  end
end
