# frozen_string_literal: true

module Warb
  module Resources
    class Button < Resource
      attr_accessor :index, :sub_type

      def build_payload
        {
          type: "button",
          sub_type: sub_type || @params[:sub_type],
          index: index || @params[:index],
          parameters: []
        }
      end
    end
  end
end
