# frozen_string_literal: true

module Warb
  class Messages
    extend Forwardable

    def_delegators :@interactive_messages, :send_list, :send_reply_button, :send_call_to_action_url
    def_delegators :@location_messages, :send_location, :send_location_request

    def initialize(client)
      @client = client
      @interactive_messages = InteractiveMessages.new(client)
      @location_messages = LocationMessages.new(client)
    end

    def send_message(recipient_number:, message:)
      data = {
        messaging_product: Warb::MESSAGING_PRODUCT,
        recipient_type: "individual",
        to: recipient_number,
        type: "text",
        text: {
          preview_url: false,
          body: message
        }
      }.to_json

      @client.conn.post("messages", data)
    end

    def send_image(recipient_number:, media_id:, caption: nil)
      data = {
        messaging_product: Warb::MESSAGING_PRODUCT,
        recipient_type: "individual",
        to: recipient_number,
        type: "image",
        image: {
          id: media_id,
          caption: caption
        }
      }.to_json

      @client.conn.post("messages", data)
    end

    def send_audio(recipient_number:, media_id:)
      data = {
        messaging_product: Warb::MESSAGING_PRODUCT,
        recipient_type: "individual",
        to: recipient_number,
        type: "audio",
        audio: {
          id: media_id
        }
      }.to_json

      @client.conn.post("messages", data)
    end

    def send_document(recipient_number:, media_id:, caption: nil, filename: nil)
      data = {
        messaging_product: Warb::MESSAGING_PRODUCT,
        recipient_type: "individual",
        to: recipient_number,
        type: "document",
        document: {
          id: media_id,
          caption: caption,
          filename: filename
        }
      }.to_json

      @client.conn.post("messages", data)
    end

    def send_video(recipient_number:, media_id:, caption: nil)
      data = {
        messaging_product: Warb::MESSAGING_PRODUCT,
        recipient_type: "individual",
        to: recipient_number,
        type: "video",
        video: {
          id: media_id,
          caption: caption
        }
      }.to_json

      @client.conn.post("messages", data)
    end
  end
end
