# frozen_string_literal: true

module Warb
  module Components
    class VoiceCallButton < Button
      BUTTON_TYPE = "voice_call"

      private

      def button_type
        BUTTON_TYPE
      end
    end
  end
end
