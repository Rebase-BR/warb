# frozen_string_literal: true

module Warb
  module Components
    class Button < Component
      attr_accessor :index, :sub_type

      def to_h
        {
          type: "button",
          sub_type: sub_type || @params[:sub_type],
          index: index || @params[:index]
        }
      end
    end
  end
end 