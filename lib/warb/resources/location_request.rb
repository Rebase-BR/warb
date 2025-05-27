# frozen_string_literal: true

module Warb
  module Resources
    class LocationRequest < Resource
      def build_payload
        {
          type: "interactive",
          interactive: {
            type: "location_request_message",
            body: {
              text: @params[:body_text]
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
