# frozen_string_literal: true

module Warb
  module Resources
    class Text < Resource
      attr_accessor :content, :text, :message, :preview_url, :parameter_name, :examples

      def build_header
        { type: 'text', text: message_per_priority }.tap do |header|
          parameter_name ||= @params[:parameter_name]
          header[:parameter_name] = parameter_name unless parameter_name.nil?
        end
      end

      def build_payload
        {
          type: 'text',
          text: {
            preview_url: preview_url || @params[:preview_url],
            body: message_per_priority
          }
        }
      end

      def build_template_named_parameter(parameter_name)
        {
          type: 'text',
          text: message_per_priority,
          parameter_name: parameter_name
        }
      end

      def build_template_positional_parameter
        {
          type: 'text',
          text: message_per_priority
        }
      end

      def build_template_example_parameter
        { type: 'body', text: message_per_priority }.tap do |param|
          examples ||= @params[:examples]

          next unless examples.is_a?(Array)

          param[:example] = { body_text: [examples] }
        end
      end

      private

      def message_per_priority
        content || text || message || @params[:content] || @params[:text] || @params[:message]
      end
    end
  end
end
