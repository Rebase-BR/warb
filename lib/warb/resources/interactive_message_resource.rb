# frozen_string_literal: true

module Warb
  module Resources
    class InteractiveMessageResource < Resource
      attr_accessor :header, :body, :footer, :action

      protected

      def common_interactive_message_params(interactive_message_type, with_header: true, with_footer: true)
        { type: "interactive" }.tap do |params|
          params[:interactive] = {
            type: interactive_message_type.to_s,
            body: body_data,
            action: action_data
          }

          params[:interactive][:header] = header_data if with_header
          params[:interactive][:footer] = footer_data if with_footer
        end
      end

      private

      def header_data
        (header || @params[:header])&.to_h
      end

      def body_data
        {
          text: body || @params[:body]
        }
      end

      def footer_data
        {
          text: footer || @params[:footer]
        }
      end

      def action_data
        (action || @params[:action])&.to_h
      end
    end
  end
end
