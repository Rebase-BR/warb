# frozen_string_literal: true

require_relative "components/header"
require_relative "components/body"
require_relative "components/footer"
require_relative "components/action"

module Warb
  class InteractiveMessages
    def initialize(client)
      @client = client
    end

    def send_list(recipient_number:, body:, action:, header: nil, footer: nil)
      data = {
        messaging_product: Warb::MESSAGING_PRODUCT,
        recipient_type: "individual",
        to: recipient_number,
        type: "interactive",
        interactive: {
          type: "list",
          header: header&.to_h,
          body: body&.to_h,
          footer: footer&.to_h,
          action: action.to_h
        }
      }

      @client.post("messages", data)
    end

    def send_reply_button(recipient_number:, body:, header: nil, footer: nil, action: nil)
      data = {
        messaging_product: Warb::MESSAGING_PRODUCT,
        recipient_type: "individual",
        to: recipient_number,
        type: "interactive",
        interactive: {
          type: "button",
          header: header&.to_h,
          body: body&.to_h,
          footer: footer&.to_h,
          action: action.to_h
        }
      }

      @client.post("messages", data)
    end

    def send_call_to_action_url(recipient_number:, body:, header: nil, footer: nil, action: nil)
      data = {
        messaging_product: Warb::MESSAGING_PRODUCT,
        recipient_type: "individual",
        to: recipient_number,
        type: "interactive",
        interactive: {
          type: "cta_url",
          header: header&.to_h,
          body: body&.to_h,
          footer: footer&.to_h,
          action: action.to_h
        }
      }

      @client.post("messages", data)
    end
  end
end
