# frozen_string_literal: true

module Warb
  module Resources
    class Template < Resource
      attr_accessor :name, :language, :resources

      def initialize(**params)
        super(**params)

        @name = params[:name]
        @language = params[:language]
        @resources = params[:resources]
      end

      def build_payload
        {
          type: "template",
          template: {
            name: name,
            language: {
              code: language
            },
            components: [
              {
                type: "body",
                parameters: build_parameters
              }
            ]
          }
        }
      end

      def add_currency_parameter(parameter_name = nil, **params, &block)
        add_parameter(parameter_name, Currency.new(**params), &block)
      end

      def add_date_time_parameter(parameter_name = nil, **params, &block)
        add_parameter(parameter_name, DateTime.new(**params), &block)
      end

      def add_text_parameter(parameter_name = nil, **params, &block)
        add_parameter(parameter_name, Text.new(**params), &block)
      end

      private

      def build_parameters
        case resources
        when Hash
          named_parameters
        when Array
          positional_parameters
        end
      end

      def named_parameters
        resources.map do |parameter_name, resource|
          resource.build_template_named_parameter(parameter_name.to_s)
        end
      end

      def positional_parameters
        resources.map(&:build_template_positional_parameter)
      end

      def add_parameter(parameter_name, instance, &block)
        case resources
        when Hash
          resources[parameter_name.to_s] = instance
        when Array
          resources << instance
        else
          initialize_resources(parameter_name, instance, &block)
        end

        block_given? ? instance.tap(&block) : instance
      end

      def initialize_resources(parameter_name, instance)
        if parameter_name.nil?
          @resources = []
          @resources << instance
        else
          @resources = {}
          @resources[parameter_name] = instance
        end
      end
    end
  end
end
