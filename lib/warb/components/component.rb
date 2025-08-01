# frozen_string_literal: true

module Warb
  module Components
    class Component
      def initialize(**params)
        @params = params
      end

      def to_h
        raise NotImplementedError
      end

      protected

      attr_reader :params
    end
  end
end 