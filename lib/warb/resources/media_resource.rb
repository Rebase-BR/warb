# frozen_string_literal: true

module Warb
  module Resources
    class MediaResource < Resource
      attr_accessor :media_id, :link, :caption, :filename

      protected

      def common_media_params(media_type, with_caption: false, with_filename: false)
        { type: media_type.to_s }.tap do |params|
          params[media_type] = {
            id: media_id || @params[:media_id],
            link: link || @params[:link]
          }

          params[media_type][:caption] = caption || @params[:caption] if with_caption
          params[media_type][:filename] = filename || @params[:filename] if with_filename
        end
      end
    end
  end
end
