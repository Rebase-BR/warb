module Warb
  class TemplateDispatcher < Dispatcher
    def create(**args)
      template = Resources::Template.new(**args)

      @client.post("message_templates", template.creation_payload, endpoint_prefix: :business_id)
    end

    def delete(template_name)
      @client.delete("message_templates", { name: template_name }, endpoint_prefix: :business_id).body
    end
  end
end
