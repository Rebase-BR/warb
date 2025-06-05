# frozen_string_literal: true

module Warb
  module Resources
    class Sticker < MediaResource
      def build_payload
        common_media_params(:sticker)
      end
    end
  end
end
