# frozen_string_literal: true

module Warb
  module Resources
    class Image < Resource
      attr_accessor :media_id, :link, :caption

      def build_header
        common_image_params
      end

      def build_payload
        params = common_image_params
        params[:image][:caption] = caption || @params[:caption]
        params
      end

      private

      def common_image_params
        {
          type: "image",
          image: {
            id: media_id || @params[:media_id],
            link: link || @params[:link]
          }
        }
      end
    end
  end
end
