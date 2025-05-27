# frozen_string_literal: true

module Warb
  module Resources
    class Video < Resource
      def build_header
        common_video_params
      end

      def build_payload
        params = common_video_params
        params[:video][:caption] = @params[:caption]
        params
      end

      private

      def common_video_params
        {
          type: "video",
          video: {
            id: @params[:media_id],
            link: @params[:link]
          }
        }
      end
    end
  end
end
