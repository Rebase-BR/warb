# frozen_string_literal: true

module Warb
  module Resources
    class Sticker < Resource
      attr_accessor :media_id, :link

      def build_payload
        {
          type: "sticker",
          sticker: {
            id: media_id || @params[:media_id],
            link: link || @params[:link]
          }
        }
      end
    end
  end
end
