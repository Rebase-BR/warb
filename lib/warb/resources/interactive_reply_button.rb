# frozen_string_literal: true

module Warb
  module Resources
    class InteractiveReplyButton < InteractiveMessageResource
      def build_payload
        check_errors

        common_interactive_message_params(:button)
      end

      def set_text_header(text)
        @header = Warb::Resources::Text.new(text:).build_header
      end

      def set_image_header(media_id: nil, link: nil)
        @header = Warb::Resources::Image.new(media_id:, link:).build_header
      end

      def set_video_header(media_id: nil, link: nil)
        @header = Warb::Resources::Video.new(media_id:, link:).build_header
      end

      def set_document_header(media_id: nil, link: nil, filename: nil)
        @header = Warb::Resources::Document.new(media_id:, link:, filename:).build_header
      end

      def build_action(&block)
        @action = Warb::Components::ReplyButtonAction.new

        block_given? ? @action.tap(&block) : @action
      end
    end
  end
end
