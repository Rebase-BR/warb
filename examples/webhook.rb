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
      message_id = message["id"]

      Warb.indicator.mark_as_read(message_id)

      Warb.message.dispatch(message["from"], reply_to: message_id, message: "Echo #{message["text"]["body"]}")

      reaction = {
        message_id:,
        emoji: "✅"
      }

      Warb.reaction.dispatch(message["from"], **reaction)
    elsif message && message["type"] == "location"
      message_id = message["id"]

      Warb.indicator.mark_as_read(message_id)

      # indicate the response is being processed
      Warb.indicator.send_typing_indicator(message_id)

      # wait a little before send the actual response, so the user can see the typing indicator
      sleep 2

      location = {
        latitude: message["location"]["latitude"],
        longitude: message["location"]["longitude"],
        name: message["location"]["name"],
        address: message["location"]["address"]
      }

      Warb.location.dispatch(message["from"], reply_to: message_id, **location)
    elsif message && message["type"] == "image"
      message_id = message["id"]

      Warb.indicator.mark_as_read(message_id)

      # for images, documents, videos, audios and stickers, you may need to keep the respective field id
      # the respective ids are:
      #   message["image"]["id"]
      #   message["sticker"]["id"]
      #   message["audio"]["id"]
      #   message["document"]["id"]
      #   message["video"]["id"]
      #
      # and only one of them is presented within the webhook response data
      #
      # with the media id in hands, you can re-send it and/or download it
      #
      # below, we resend the received image, using its id.

      image = {
        media_id: message["image"]["id"],
        link: message["image"]["link"],
        caption: message["image"]["caption"]
      }

      Warb.image.dispatch(message["from"], reply_to: message_id, **image)

      # and here, we download the received image
      Warb.image.download(media_id: image[:media_id], file_path: "#{Time.now}.jpg")
    elsif message && message["type"] == "document"
      message_id = message["id"]

      Warb.indicator.mark_as_read(message_id)

      document = {
        id: message["document"]["id"],
        link: message["document"]["link"],
        caption: message["document"]["caption"],
        filename: message["document"]["filename"]
      }

      Warb.document.dispatch(message["from"], reply_to: message_id, **document)
    elsif message && message["type"] == "sticker"
      message_id = message["id"]

      Warb.indicator.mark_as_read(message_id)

      sticker = {
        media_id: message["sticker"]["id"],
        link: message["sticker"]["link"]
      }

      Warb.sticker.dispatch(message["from"], reply_to: message_id, **sticker)
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
end
