# frozen_string_literal: true

module Warb
  module Resources
    class Resource
      def initialize(**params)
        @params = params
      end

      def call(recipient_number, reply_to: nil)
        common_resources_params(recipient_number, reply_to).merge build_payload
      end

      def build_header
        raise NotImplementedError
      end

      def build_payload
        raise NotImplementedError
      end

      def build_template_positional_parameter
        raise NotImplementedError
      end

      def build_template_named_parameter(paramater_name)
        raise NotImplementedError
      end

      def set_text_header
        raise NotImplementedError
      end

      def set_image_header
        raise NotImplementedError
      end

      def set_video_header
        raise NotImplementedError
      end

      def set_document_header
        raise NotImplementedError
      end

      protected

      def common_resources_params(recipient_number, reply_to)
        {
          messaging_product: Warb::MESSAGING_PRODUCT,
          recipient_type: Warb::RECIPIENT_TYPE,
          to: recipient_number
        }.tap do |params|
          params[:context] = { message_id: reply_to } if reply_to
        end
      end
    end
  end
end
