# frozen_string_literal: true

module Warb
  module Components
    class CopyCodeButton < Button
      BUTTON_TYPE = 'copy_code'

      attr_accessor :coupon_code

      def to_h
        button_payload = super

        if coupon_code || @params[:coupon_code]
          button_payload[:parameters] = Array.new(1, {
                                                    type: 'coupon_code',
                                                    coupon_code: coupon_code || @params[:coupon_code]
                                                  })
        end

        button_payload
      end

      private

      def button_type
        BUTTON_TYPE
      end
    end
  end
end
