# frozen_string_literal: true

module Warb
  module Resources
    class InteractiveReplyButton < Resource
      def build_payload
        {
          type: "interactive",
          interactive: {
            type: "button",
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
