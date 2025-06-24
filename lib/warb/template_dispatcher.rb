module Warb
  class TemplateDispatcher < Dispatcher
    def create(**args)
      template = Resources::Template.new(**args)

      @client.post("message_templates", template.creation_payload, endpoint_prefix: :business_id)
    end
  end
end
