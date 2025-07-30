# frozen_string_literal: true

module Warb
  module Resources
    class UrlButton < Button
      attr_accessor :text

      def build_payload
        button_payload = super

        if text || @params[:text]
          button_payload[:parameters].push({
            type: "text",
            text: text || @params[:text]
          })
        end

        button_payload
      end
    end
  end
end
