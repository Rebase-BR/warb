# frozen_string_literal: true

module Warb
  class TemplateDispatcher < Dispatcher
    def list(**args)
      filter = args.slice(:limit, :fields, :after, :before)
      filter[:fields] = filter[:fields].join(',') if filter[:fields].is_a?(Array)

      @client.get('message_templates', endpoint_prefix: :business_id, data: filter).body
    end
  end
end
