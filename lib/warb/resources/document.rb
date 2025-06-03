# frozen_string_literal: true

module Warb
  module Resources
    class Document < Resource
      attr_accessor :media_id, :link, :filename, :caption

      def build_header
        common_document_params
      end

      def build_payload
        params = common_document_params
        params[:document][:caption] = caption || @params[:caption]
        params
      end

      private

      def common_document_params
        {
          type: "document",
          document: {
            id: media_id || @params[:media_id],
            filename: filename || @params[:filename],
            link: link || @params[:link]
          }
        }
      end
    end
  end
end
