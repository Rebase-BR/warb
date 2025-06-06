# frozen_string_literal: true

module Warb
  module Components
    class Phone
      attr_accessor :phone, :type, :wa_id

      def initialize(**params)
        @phone = params[:phone]
        @type = params[:type]
        @wa_id = params[:wa_id]
      end

      def to_h
        {
          phone: phone,
          type: type,
          wa_id: wa_id
        }
      end
    end
  end
end
