# frozen_string_literal: true

module Warb
  module Resources
    class LocationRequest < Resource
      attr_accessor :body_text

      def build_payload
        {
          type: "interactive",
          interactive: {
            type: "location_request_message",
            body: {
              text: body_text || @params[:body_text]
            },
            action: {
              name: "send_location"
            }
          }
        }
      end
    end
  end
end
