# frozen_string_literal: true

module Warb
  module Resources
    class Image < MediaResource
      def build_header
        common_media_params(:image)
      end

      def build_payload
        common_media_params(:image, with_caption: true)
      end
    end
  end
end
