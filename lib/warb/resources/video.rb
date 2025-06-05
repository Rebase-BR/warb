# frozen_string_literal: true

module Warb
  module Resources
    class Video < MediaResource
      def build_header
        common_media_params(:video)
      end

      def build_payload
        common_media_params(:video, with_caption: true)
      end

      private

      def common_video_params
        {
          type: "video",
          video: {
            id: media_id || @params[:media_id],
            link: link || @params[:link]
          }
        }
      end
    end
  end
end
