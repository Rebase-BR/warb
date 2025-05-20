# frozen_string_literal: true

module Warb
  module Components
    class Footer
      attr_reader :content

      def initialize(content:)
        @content = content
      end

      def to_h
        { text: content }
      end
    end
  end
end
