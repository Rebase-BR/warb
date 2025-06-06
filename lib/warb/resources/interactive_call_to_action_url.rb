# frozen_string_literal: true

module Warb
  module Resources
    class InteractiveCallToActionUrl < InteractiveMessageResource
      def build_payload
        common_interactive_message_params(:cta_url)
      end

      def set_text_header(text)
        @header = Warb::Resources::Text.new(text:).build_header
      end

      def set_image_header(link: nil)
        @header = Warb::Resources::Image.new(link:).build_header
      end

      def set_video_header(link: nil)
        @header = Warb::Resources::Video.new(link:).build_header
      end

      def set_document_header(link: nil, filename: nil)
        @header = Warb::Resources::Document.new(link:, filename:).build_header
      end

      def build_action(&block)
        @action = Warb::Components::CTAAction.new

        block_given? ? @action.tap(&block) : @action
      end
    end
  end
end
