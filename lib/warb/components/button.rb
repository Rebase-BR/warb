# frozen_string_literal: true

module Warb
  module Components
    class Button < Component
      attr_accessor :index, :sub_type

      def initialize(**params)
        params[:sub_type] = button_type unless params[:sub_type]

        super(**params)
      end

      def to_h
        {
          type: "button",
          sub_type: sub_type || @params[:sub_type],
          index: index || @params[:index]
        }
      end

      private

      def button_type
        raise NotImplementedError
      end
    end
  end
end
