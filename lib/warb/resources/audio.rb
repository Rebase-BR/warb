# frozen_string_literal: true

module Warb
  module Resources
    class Audio < Resource
      def build_payload
        {
          type: "audio",
          audio: {
            id: @params[:media_id],
            link: @params[:link]
          }
        }
      end
    end
  end
end
