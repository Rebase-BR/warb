# frozen_string_literal: true

module Warb
  module Resources
    class Resource
      def initialize(**params)
        @params = params
      end

      def call(recipient_number)
        common_resources_params(recipient_number).merge build_payload
      end

      def build_header
        raise NotImplementedError
      end

      def build_payload(recipient_number)
        raise NotImplementedError
      end

      protected

      def common_resources_params(recipient_number)
        {
          messaging_product: Warb::MESSAGING_PRODUCT,
          recipient_type: Warb::RECIPIENT_TYPE,
          to: recipient_number
        }
      end
    end
  end
end
