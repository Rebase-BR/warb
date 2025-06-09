# frozen_string_literal: true

module Warb
  class Error < StandardError
    attr_reader :errors

    def initialize(errors: nil)
      super("Errors were found: #{errors.inspect}")

      @errors = errors
    end

    class << self
      def at_least(count)
        noun = count > 1 ? "items" : "item"

        "at_least_#{count}_#{noun}".to_sym
      end

      def at_most(count)
        noun = count > 1 ? "items" : "item"

        "at_most_#{count}_#{noun}".to_sym
      end

      def cannot_be_empty
        :cannot_be_empty
      end

      def invalid_value
        :invalid_value
      end

      def not_unique
        :not_unique
      end

      def required
        :required
      end

      def required_if_multiple_sections
        :required_if_multiple_sections
      end

      def too_long(max_length)
        noun = max_length > 1 ? "characters" : "character"

        "no_longer_than_#{max_length}_#{noun}".to_sym
      end
    end
  end
end
