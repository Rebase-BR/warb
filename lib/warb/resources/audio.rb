# frozen_string_literal: true

module Warb
  module Resources
    class Audio < MediaResource
      def build_payload
        common_media_params(:audio)
      end
    end
  end
end
