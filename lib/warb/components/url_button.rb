# frozen_string_literal: true

module Warb
  module Components
    class UrlButton < Button
      BUTTON_TYPE = 'url'

      attr_accessor :text

      def to_h
        button_payload = super

        if text || @params[:text]
          button_payload[:parameters] = Array.new(1, {
                                                    type: 'text',
                                                    text: text || @params[:text]
                                                  })
        end

        button_payload
      end

      private

      def button_type
        BUTTON_TYPE
      end
    end
  end
end
