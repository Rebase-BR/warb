# frozen_string_literal: true

module Warb
  module Components
    class QuickReplyButton < Button
      BUTTON_TYPE = 'quick_reply'

      private

      def button_type
        BUTTON_TYPE
      end
    end
  end
end
