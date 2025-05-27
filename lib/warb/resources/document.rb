# frozen_string_literal: true

module Warb
  module Resources
    class Document < Resource
      def build_header
        common_document_params
      end

      def build_payload
        params = common_document_params
        params[:document][:caption] = @params[:caption]
        params
      end

      private

      def common_document_params
        {
          type: "document",
          document: {
            id: @params[:media_id],
            filename: @params[:filename]
          }
        }
      end
    end
  end
end
