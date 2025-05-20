# frozen_string_literal: true

module Warb
  module Components
    class Header
      attr_reader :type, :content

      def initialize(content:, type: "text")
        @type = type
        @content = content
      end

      def to_h
        raise NotImplementedError, "Subclasses must implement a to_h method"
      end
    end

    class TextHeader < Header
      def to_h
        raise ArgumentError, "#{self.class} type must be \"text\"" unless type == "text"

        { type:, text: content }
      end
    end

    class VideoHeader < Header
      def to_h
        raise ArgumentError, "#{self.class} type must be \"video\"" unless type == "video"

        { type:, video: { id:, link: } }
      end
    end

    class ImageHeader < Header
      def to_h
        raise ArgumentError, "#{self.class} type must be \"image\"" unless type == "image"

        { type:, image: { id:, link: } }
      end
    end

    class DocumentHeader < Header
      def to_h
        raise ArgumentError, "#{self.class} type must be \"document\"" unless type == "document"

        { type:, document: body }
      end
    end
  end
end
