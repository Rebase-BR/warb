# frozen_string_literal: true

module Warb
  module Resources
    class InteractiveList < InteractiveMessageResource
      def build_payload
        common_interactive_message_params(:list)
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
