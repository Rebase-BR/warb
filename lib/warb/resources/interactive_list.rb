# frozen_string_literal: true

module Warb
  module Resources
    class InteractiveList < Resource
      attr_accessor :header, :body, :footer, :action

      def build_payload
        {
          type: "interactive",
          interactive: {
            type: "list",
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

      def build_action(&block)
        @action = Warb::Components::ListAction.new

        block_given? ? @action.tap(&block) : @action
      end
    end
  end
end
