# frozen_string_literal: true

module Warb
  module Resources
    class InteractiveCallToActionUrl < Resource
      def build_payload
        {
          type: "interactive",
          interactive: {
            type: "cta_url",
            header: @params[:header]&.to_h,
            body: {
              text: @params[:body]
            },
            footer: {
              text: @params[:footer]
            },
            action: @params[:action]&.to_h
          }
        }
      end
    end
  end
end
