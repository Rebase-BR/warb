# frozen_string_literal: true

module Warb
  module Resources
    class LocationRequest < InteractiveMessageResource
      def build_payload
        check_errors

        common_interactive_message_params(:location_request_message, with_header: false, with_footer: false)
      end

      private

      def action_data
        {
          name: "send_location"
        }
      end

      def max_body_text_length
        1024
      end
    end
  end
end
