# frozen_string_literal: true

module Warb
  module Resources
    class DateTime < Resource
      attr_accessor :date_time

      def initialize(date_time = nil, **params)
        super(**params)

        @date_time = date_time
      end

      def build_template_named_parameter(parameter_name)
        common_date_time_params.merge(parameter_name: parameter_name)
      end

      def build_template_positional_parameter
        common_date_time_params
      end

      private

      def common_date_time_params
        {
          type: "date_time",
          date_time: {
            fallback_value: date_time
          }
        }
      end
    end
  end
end
