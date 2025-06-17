# frozen_string_literal: true

module Warb
  module Resources
    class Text < Resource
      attr_accessor :content, :text, :message, :preview_url

      def build_header
        { type: "text", text: message_per_priority }
      end

      def build_payload
        {
          type: "text",
          text: {
            preview_url: preview_url || @params[:preview_url],
            body: message_per_priority
          }
        }
      end

      def build_template_named_parameter(parameter_name)
        {
          type: "text",
          text: message_per_priority,
          parameter_name: parameter_name
        }
      end

      def build_template_positional_parameter
        {
          type: "text",
          text: message_per_priority
        }
      end

      private

      def message_per_priority
        content || text || message || @params[:content] || @params[:text] || @params[:message]
      end
    end
  end
end
