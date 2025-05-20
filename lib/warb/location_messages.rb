module Warb
  class LocationMessages
    def initialize(client)
      @client = client
    end

    def send_location(recipient_number:, latitude:, longitude:, name: nil, address: nil)
      data = {
        messaging_product: Warb::MESSAGING_PRODUCT,
        recipient_type: "individual",
        to: recipient_number,
        type: "location",
        location: {
          latitude: latitude,
          longitude: longitude,
          name: name,
          address: address
        }
      }.to_json

      @client.conn.post("messages", data)
    end

    def send_location_request(recipient_number:, body:)
      data = {
        messaging_product: Warb::MESSAGING_PRODUCT,
        recipient_type: "individual",
        to: recipient_number,
        type: "interactive",
        interactive: {
          type: "location_request_message",
          body: {
            text: body
          },
          action: {
            name: "send_location"
          }
        }
      }.to_json

      @client.conn.post("messages", data)
    end
  end
end
