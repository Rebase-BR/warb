# frozen_string_literal: true

module Warb
  module Resources
    class Audio < Resource
      attr_accessor :media_id, :link

      def build_payload
        {
          type: 'audio',
          audio: {
            id: media_id || @params[:media_id],
            link: link || @params[:link]
          }
        }
      end
    end
  end
end
