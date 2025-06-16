# frozen_string_literal: true

module Warb
  module Resources
    class Template < Resource
      attr_accessor :name, :language, :parameters

      def initialize(**params)
        super(**params)

        @name = params[:name]
        @language = params[:language]
        @parameters = params[:parameters]
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
        case parameters
        when Hash
          named_parameters
        when Array
          positional_parameters
        end
      end

      def named_parameters
        parameters.map do |parameter_name, parameter|
          {
            type: "text",
            text: parameter,
            parameter_name: parameter_name.to_s
          }
        end
      end

      def positional_parameters
        parameters.map do |parameter|
          {
            type: "text",
            text: parameter
          }
        end
      end
    end
  end
end
