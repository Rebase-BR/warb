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
    end
  end
end
