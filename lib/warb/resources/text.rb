# frozen_string_literal: true

module Warb
  module Resources
    class Text < Resource
      attr_accessor :content, :text, :message, :preview_url

      def build_header
        check_header_errors

        { type: "text", text: message_per_priority }
      end

      def build_payload
        check_payload_errors

        {
          type: "text",
          text: {
            preview_url: preview_url || @params[:preview_url],
            body: message_per_priority
          }
        }
      end

      private

      def check_header_errors
        errors = []

        check_text_errors(errors, max_length: 60)

        raise Warb::Error.new(errors: errors) unless errors.empty?
      end

      def check_payload_errors
        errors = []

        check_text_errors(errors, max_length: 4096)

        raise Warb::Error.new(errors: errors) unless errors.empty?
      end

      def check_text_errors(errors, max_length:)
        if message_per_priority.nil? || message_per_priority.empty?
          errors << "Text is required"
        elsif message_per_priority.length > max_length
          errors << "Text length should be no longer than #{max_length} characters"
        end
      end

      def message_per_priority
        content || text || message || @params[:content] || @params[:text] || @params[:message]
      end
    end
  end
end
