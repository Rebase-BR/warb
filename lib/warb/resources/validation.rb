# frozen_string_literal: true

module Warb
  module Resources
    module Validation
      def blank?(val)
        val.respond_to?(:empty?) ? val.empty? : !val
      end

      def raw_value(field)
        respond_to?(field) ? public_send(field) : nil
      end

      def resolve(field, default = nil)
        val = raw_value(field)
        val = @params[field] if blank?(val) && defined?(@params) && @params&.key?(field)
        val = default if blank?(val) && !default.nil?
        val
      end

      def validates(field, required: false, message: nil)
        needed = required.respond_to?(:call) ? required.call : required
        return unless needed
        return unless blank?(resolve(field))

        raise ArgumentError, (message || "#{field} is required")
      end
    end
  end
end
