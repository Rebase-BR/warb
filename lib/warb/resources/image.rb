# frozen_string_literal: true

module Warb
  module Resources
    class Image < Resource
      def build_header
        common_image_params
      end

      def build_payload
        params = common_image_params
        params[:image][:caption] = @params[:caption]
        params
      end

      private

      def common_image_params
        {
          type: "image",
          image: {
            id: @params[:id],
            link: @params[:link]
          }
        }
      end
    end
  end
end
