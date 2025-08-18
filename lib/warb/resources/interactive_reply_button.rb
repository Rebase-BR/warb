# frozen_string_literal: true

module Warb
  module Resources
    class InteractiveReplyButton < Resource
      attr_accessor :header, :body, :footer, :action

      # rubocop:disable Metrics/MethodLength
      def build_payload
        {
          type: 'interactive',
          interactive: {
            type: 'button',
            header: header || @params[:header]&.to_h,
            body: {
              text: body || @params[:body]
            },
            footer: {
              text: footer || @params[:footer]
            },
            action: (action || @params[:action])&.to_h
          }
        }
      end
      # rubocop:enable Metrics/MethodLength

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

      def build_action(**params, &)
        @action = Warb::Components::ReplyButtonAction.new(**params)

        block_given? ? @action.tap(&) : @action
      end
    end
  end
end
