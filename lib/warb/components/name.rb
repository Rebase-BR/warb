# frozen_string_literal: true

module Warb
  module Components
    class Name
      attr_accessor :formatted_name, :first_name, :last_name, :middle_name, :suffix, :prefix

      def initialize(**params)
        @formatted_name = params[:formatted_name]
        @first_name = params[:first_name]
        @last_name = params[:last_name]
        @middle_name = params[:middle_name]
        @suffix = params[:suffix]
        @prefix = params[:prefix]
      end

      def to_h
        {
          formatted_name: formatted_name,
          first_name: first_name,
          last_name: last_name,
          middle_name: middle_name,
          suffix: suffix,
          prefix: prefix
        }
      end
    end
  end
end
