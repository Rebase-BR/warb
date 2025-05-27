module Warb
  class Dispatcher
    def initialize(klass, client)
      @klass = klass
      @client = client
    end

    def dispatch(recipient_number, **args)
      data = @klass.new(**args).call(recipient_number)

      @client.post("messages", data)
    end
  end
end
