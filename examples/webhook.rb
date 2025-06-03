require "sinatra/base"
require "faraday"

class Webhook < Sinatra::Base
  configure do
    set :bind, "0.0.0.0"
    set :port, 3000
    set :host_authorization, { permitted_hosts: [] }
  end

  post "/webhook" do
    request_body = JSON.parse(request.body.read)

    puts "\n🪝 Incoming webhook message: #{request_body}"

      message = request_body.dig("entry", 0, "changes", 0, "value", "messages", 0)

    if message && message["type"] == "text"
      sender_id = request_body.dig("entry", 0, "changes", 0, "value", "metadata", "phone_number_id")
      message_id = message["id"]

      mark_as_read(message_id:, sender_id:)

      Warb.message.dispatch(message["from"], reply_to: message_id, message: "Echo #{message["text"]["body"]}")

      # send reaction
      conn.post(
        "#{sender_id}/messages",
        {
          messaging_product: Warb::MESSAGING_PRODUCT,
          to: message["from"],
          type: "reaction",
          reaction: {
            message_id:,
            emoji: "✅"
          }
        }
      )
    elsif message && message["type"] == "location"
      sender_id = request_body.dig("entry", 0, "changes", 0, "value", "metadata", "phone_number_id")
      message_id = message["id"]

      mark_as_read(message_id:, sender_id:)

      location = {
        latitude: message["location"]["latitude"],
        longitude: message["location"]["longitude"],
        name: message["location"]["name"],
        address: message["location"]["address"]
      }

      Warb.location.dispatch(message["from"], reply_to: message_id, **location)
    elsif message && message["type"] == "image"
      sender_id = request_body.dig("entry", 0, "changes", 0, "value", "metadata", "phone_number_id")
      message_id = message["id"]

      mark_as_read(message_id:, sender_id:)

      image = {
        id: message["image"]["id"],
        link: message["image"]["link"],
        caption: message["image"]["caption"]
      }

      Warb.image.dispatch(message["from"], reply_to: message_id, **image)
    elsif message && message["type"] == "document"
      sender_id = request_body.dig("entry", 0, "changes", 0, "value", "metadata", "phone_number_id")
      message_id = message["id"]

      mark_as_read(message_id:, sender_id:)

      document = {
        id: message["document"]["id"],
        link: message["document"]["link"],
        caption: message["document"]["caption"],
        filename: message["document"]["filename"]
      }

      Warb.document.dispatch(message["from"], reply_to: message_id, **document)
    elsif message && message["type"] == "sticker"
      sender_id = request_body.dig("entry", 0, "changes", 0, "value", "metadata", "phone_number_id")
      message_id = message["id"]

      mark_as_read(message_id:, sender_id:)

      conn.post(
        "#{sender_id}/messages",
        {
          messaging_product: Warb::MESSAGING_PRODUCT,
          to: message["from"],
          type: "sticker",
          sticker: {
            id: message["sticker"]["id"],
            link: message["sticker"]["link"]
          },
          context: { message_id: }
        }
      )
      # you could keep adding verifications for different types of messages...
      # elsif message && message["type"] == "image"
      # elsif message && message["type"] == "video"
      # elsif message && message["type"] == "contacts ?"
      # elsif message && message["type"] == "button"
      # elsif message && message["type"] == "interactive"
      # elsif message && message["type"] == "unknown"
    end

    status 200
  end

  # this is the endpoint which gets called to verify the server within the Meta's API
  # you can do whatever you want here to verify your server
  # returning the challenge value which was received as query param is enough
  get "/webhook" do
    mode = params["hub.mode"]
    token = params["hub.verify_token"]
    challenge = params["hub.challenge"]

    if mode == "subscribe" && token == Warb.configuration.webhook_verify_token
      status 200
      body challenge

      puts "\n✨ Webhook verified successfully!"
    else
      status 403
    end
  end

  run! if app_file == $PROGRAM_NAME

  private

  def conn
    @conn ||= Faraday.new("https://graph.facebook.com/v22.0") do |conn|
      conn.headers["Authorization"] = "Bearer #{Warb.configuration.access_token}" if Warb.configuration.access_token
      conn.request(:json)
      conn.response(:json)
    end
  end

  def mark_as_read(message_id:, sender_id:)
    conn.post(
      "#{sender_id}/messages",
      {
        messaging_product: Warb::MESSAGING_PRODUCT,
        status: "read",
        message_id: message_id
      }
    )
  end
end
