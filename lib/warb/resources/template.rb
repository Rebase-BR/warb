# frozen_string_literal: true

module Warb
  module Resources
    class Template < Resource
      attr_accessor :name, :language, :resources, :header, :buttons

      def initialize(**params)
        super(**params)

        @name = params[:name]
        @language = params[:language]
        @resources = params[:resources]
        @buttons = []
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
              component_header,
              component_body,
              *buttons
            ].compact
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

      def set_text_header(content: nil, message: nil, text: nil, parameter_name: nil, &block)
        set_header(Text.new(content:, message:, text:, parameter_name:), &block)
      end

      def set_image_header(media_id: nil, link: nil, &block)
        set_header(Image.new(media_id:, link:), &block)
      end

      def set_document_header(media_id: nil, link: nil, filename: nil, &block)
        set_header(Document.new(media_id:, link:, filename:), &block)
      end

      def set_video_header(media_id: nil, link: nil, &block)
        set_header(Video.new(media_id:, link:), &block)
      end

      def set_location_header(latitude: nil, longitude: nil, address: nil, name: nil, &block)
        set_header(Location.new(latitude:, longitude:, address:, name:), &block)
      end

      def set_quick_reply_button(index: nil, &block)
        set_button(Button.new(index:, sub_type: "quick_reply"), &block)
      end

      def set_dynamic_url_button(index: nil, text: nil, &block)
        set_button(UrlButton.new(index:, sub_type: "url", text:), &block)
      end

      def set_copy_code_button(index: nil, coupon_code: nil, &block)
        set_button(CopyCodeButton.new(index:, sub_type: "copy_code", coupon_code:), &block)
      end

      def set_voice_call_button(index: nil, &block)
        set_button(Button.new(index:, sub_type: "voice_call"), &block)
      end

      private

      def set_header(instance, &block)
        @header = instance

        block_given? ? @header.tap(&block) : @header
      end

      def set_button(instance, &block)
        return @buttons << instance.build_payload unless block_given?

        @buttons << instance.tap(&block).build_payload
      end

      def component_header
        return unless header.is_a? Resource

        {
          type: "header",
          parameters: [
            header.build_header
          ]
        }
      end

      def component_body
        return if resources.nil? || resources.empty?

        {
          type: "body",
          parameters: build_parameters
        }
      end

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
