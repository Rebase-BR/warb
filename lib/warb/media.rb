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

      response = @client.conn(as_json: false).post("media", data)

      JSON.parse(response.body)["id"]
    end

    def delete_media(media_id)
      response = @client.conn(user_related: false).delete(media_id)

      JSON.parse(response.body)["success"]
    end

    def retrieve_media(media_id)
      response = @client.conn(user_related: false).get(media_id)

      JSON.parse(response.body)
    end

    def download_media(media_url)
      raise NotImplementedError

      # media = @client.conn(url: media_url, as_json: false)

      # do something with the media here.
    end
  end
end
