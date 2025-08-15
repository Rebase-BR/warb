# frozen_string_literal: true

module Warb
  module Resources
    class Currency < Resource
      BRL = 'BRL'
      USD = 'USD'

      attr_accessor :amount, :code, :fallback

      def initialize(**params)
        super

        @code = params[:code]
        @amount = params[:amount]
        @fallback = params[:fallback]
      end

      def build_template_named_parameter(parameter_name)
        common_currency_params.merge(parameter_name: parameter_name)
      end

      def build_template_positional_parameter
        common_currency_params
      end

      private

      # rubocop:disable Naming/VariableNumber
      def common_currency_params
        {
          type: 'currency',
          currency: {
            amount_1000: amount * 1000,
            code: code,
            fallback_value: fallback || default_fallback_value
          }
        }
      end
      # rubocop:enable Naming/VariableNumber

      def default_fallback_value
        "#{amount} (#{code})"
      end
    end
  end
end
