# frozen_string_literal: true

module Warb
  class IndicatorDispatcher
    def initialize(client)
      @client = client
    end

    def mark_as_read(message_id)
      data = common_indicator_params(message_id)

      @client.post("messages", data)
    end

    private

    def common_indicator_params(message_id)
      {
        messaging_product: Warb::MESSAGING_PRODUCT,
        message_id: message_id,
        status: "read"
      }
    end
  end
end
