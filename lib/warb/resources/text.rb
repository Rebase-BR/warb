# frozen_string_literal: true

module Warb
  module Resources
    class Text < Resource
      def initialize(content = nil, **args)
        args[:content] ||= content
        super(**args)
      end

      def build_header
        { type: "text", text: content }
      end

      def build_payload
        {
          type: "text",
          text: {
            preview_url: @params[:preview_url],
            body: content
          }
        }
      end

      private

      def content
        @params[:content] || @params[:text] || @params[:message]
      end
    end
  end
end
