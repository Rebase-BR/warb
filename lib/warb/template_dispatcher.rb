module Warb
  class TemplateDispatcher < Dispatcher
    def list
      @client.get("message_templates", endpoint_prefix: :business_id).body
    end
  end
end
