# frozen_string_literal: true

module Warb
  module Resources
    class InteractiveCallToActionUrl < Resource
      attr_accessor :header, :body, :footer, :action

      def build_payload
        {
          type: "interactive",
          interactive: {
            type: "cta_url",
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
