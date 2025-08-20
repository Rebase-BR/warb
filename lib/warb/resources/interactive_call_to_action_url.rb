# frozen_string_literal: true

module Warb
  module Resources
    class InteractiveCallToActionUrl < Resource
      attr_accessor :header, :body, :footer, :action

      # rubocop:disable Metrics/MethodLength
      def build_payload
        {
          type: 'interactive',
          interactive: {
            type: 'cta_url',
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

      def add_text_header(text)
        @header = Warb::Resources::Text.new(text:).build_header
      end

      def add_image_header(link: nil)
        @header = Warb::Resources::Image.new(link:).build_header
      end

      def add_video_header(link: nil)
        @header = Warb::Resources::Video.new(link:).build_header
      end

      def add_document_header(link: nil, filename: nil)
        @header = Warb::Resources::Document.new(link:, filename:).build_header
      end

      def build_action(**params, &)
        @action = Warb::Components::CTAAction.new(**params)

        block_given? ? @action.tap(&) : @action
      end
    end
  end
end
