# frozen_string_literal: true

module Warb
  module Resources
    class Reaction < Resource
      attr_accessor :message_id, :emoji

      def build_payload
        {
          type: "reaction",
          reaction: {
            message_id: message_id || @params[:message_id],
            emoji: emoji || @params[:emoji]
          }
        }
      end
    end
  end
end
