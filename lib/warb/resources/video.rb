# frozen_string_literal: true

module Warb
  module Resources
    class Video < MediaResource
      def build_header
        check_errors

        common_media_params(:video)
      end

      def build_payload
        check_errors

        common_media_params(:video, with_caption: true)
      end
    end
  end
end
