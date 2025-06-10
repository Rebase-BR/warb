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
        check_errors

        {
          formatted_name: formatted_name,
          first_name: first_name,
          last_name: last_name,
          middle_name: middle_name,
          suffix: suffix,
          prefix: prefix
        }
      end

      private

      def check_errors
        errors = {}

        check_formatted_name_errors(errors)
        check_required_optional_names_errors(errors)

        raise Warb::Error.new(errors: errors) unless errors.empty?
      end

      def check_formatted_name_errors(errors)
        return unless formatted_name.nil? || formatted_name.empty?

        errors[:formatted_name] = Error.required
      end

      def check_required_optional_names_errors(errors)
        return unless errors[:formatted_name].nil?
        return if names_values.any? { |part| !part.nil? && !part.strip.empty? }

        errors[:formatted_name] = Error.required_at_least(count: 1, from: names)
      end

      def names
        %i[prefix first_name middle_name last_name suffix]
      end

      def names_values
        names.map { |name| send(name) }
      end
    end
  end
end
