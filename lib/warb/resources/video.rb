# frozen_string_literal: true

module Warb
  module Resources
    class Video < Resource
      attr_accessor :media_id, :link, :caption

      def build_header
        common_video_params
      end

      def build_payload
        params = common_video_params
        params[:video][:caption] = caption || @params[:caption]
        params
      end

      private

      def common_video_params
        {
          type: 'video',
          video: {
            id: media_id || @params[:media_id],
            link: link || @params[:link]
          }
        }
      end
    end
  end
end
