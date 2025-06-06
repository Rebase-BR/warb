# frozen_string_literal: true

module Warb
  module Components
    class Email
      attr_accessor :type, :email

      def initialize(**params)
        @type = params[:type]
        @email = params[:email]
      end

      def to_h
        {
          type: type,
          email: email
        }
      end
    end
  end
end
