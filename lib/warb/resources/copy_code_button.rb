# frozen_string_literal: true

module Warb
  module Resources
    class CopyCodeButton < Button
      attr_accessor :coupon_code

      def build_payload
        button_payload = super

        button_payload[:parameters].push({
          type: "coupon_code",
          coupon_code: coupon_code || @params[:coupon_code]
        })

        button_payload
      end
    end
  end
end
