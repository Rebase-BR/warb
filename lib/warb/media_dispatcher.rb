module Warb
  class MediaDispatcher < Dispatcher
    def upload(file_path:, file_type: "text/plain")
      file = Faraday::UploadIO.new(file_path, file_type)

      data = { file:, messaging_product: Warb::MESSAGING_PRODUCT }

      @client.post("media", data, multipart: true).body["id"]
    end

    def download(file_path:, media_url: nil, media_id: nil)
      media_url ||= retrieve(media_id)["url"]

      resp = downloaded_media_response(media_url)

      File.open(file_path, "wb") do |file|
        file.write(resp.body)
      end
    end

    def retrieve(media_id)
      @client.get(media_id, endpoint_prefix: nil).body
    end

    def delete(media_id)
      response_body = @client.delete(media_id, endpoint_prefix: nil).body

      return response_body["success"] if response_body["success"]

      response_body["error"]["message"]
    end

    private

    def downloaded_media_response(url)
      uri = URI(url)

      request = Net::HTTP::Get.new(uri)
      request["Authorization"] = "Bearer #{@client.access_token}"

      Net::HTTP.start(uri.hostname, uri.port, use_ssl: uri.scheme == "https") do |http|
        http.request(request)
      end
    end
  end
end
