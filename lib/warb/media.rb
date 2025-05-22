# frozen_string_literal: true

module Warb
  class Media
    attr_reader :client

    def initialize(client)
      @client = client
    end

    def upload_media(file_path:, file_type: "text/plain")
      file = Faraday::UploadIO.new(file_path, file_type)

      data = { file:, messaging_product: Warb::MESSAGING_PRODUCT }

      @client.post("media", data, multipart: true).body["id"]
    end

    def delete_media(media_id)
      response_body = @client.delete(media_id, endpoint_prefix: nil).body

      return response_body["success"] if response_body["success"]

      response_body["error"]["message"]
    end

    def retrieve_media(media_id)
      @client.get(media_id, endpoint_prefix: nil).body
    end

    def download_media(media_url)
      # raise NotImplementedError

      media = @client.get(url: media_url)

      # do something with the media here.
    end
  end
end
