# frozen_string_literal: true

module Warb
  module Components
    class URL
      attr_accessor :url, :type

      def initialize(**params)
        @type = params[:type]
        @url = params[:url]
      end

      def to_h
        {
          type: type,
          url: url
        }
      end
    end
  end
end
