# frozen_string_literal: true

module Warb
  class TemplateDispatcher < Dispatcher
    def create(**args)
      template = Resources::Template.new(**args)
      @client.post('message_templates', template.creation_payload, endpoint_prefix: :business_id)
    end

    def delete(template_name)
      @client.delete('message_templates', { name: template_name }, endpoint_prefix: :business_id).body
    end

    def list(**args)
      filter = args.slice(:limit, :fields, :after, :before)
      filter[:fields] = filter[:fields].join(',') if filter[:fields].is_a?(Array)

      @client.get('message_templates', endpoint_prefix: :business_id, data: filter).body
    end
  end
end

