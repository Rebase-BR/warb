# frozen_string_literal: true

module Warb
  module Resources
    class Document < MediaResource
      def build_header
        check_errors

        common_media_params(:document, with_filename: true)
      end

      def build_payload
        check_errors

        common_media_params(:document, with_filename: true, with_caption: true)
      end
    end
  end
end
