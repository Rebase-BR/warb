# frozen_string_literal: true

module Warb
  module Resources
    class Template < Resource
      attr_accessor :name, :language, :resources, :header, :category, :body, :buttons

      def initialize(**params)
        super

        @name = params[:name]
        @language = params[:language]
        @resources = params[:resources]
        @category = params[:category]
        @body = params[:body]
        @buttons = []
      end

      # rubocop:disable Metrics/MethodLength
      def build_payload
        {
          type: 'template',
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
      # rubocop:enable Metrics/MethodLength

      def creation_payload
        {
          name: name,
          language: language,
          category: category,
          components: [
            body&.build_template_example_parameter
          ].compact
        }
      end

      def add_currency_parameter(parameter_name = nil, **params, &)
        add_parameter(parameter_name, Currency.new(**params), &)
      end

      def add_date_time_parameter(parameter_name = nil, **params, &)
        add_parameter(parameter_name, DateTime.new(**params), &)
      end

      def add_text_parameter(parameter_name = nil, **params, &)
        add_parameter(parameter_name, Text.new(**params), &)
      end

      def add_text_header(content: nil, message: nil, text: nil, parameter_name: nil, &block)
        add_header(Text.new(content:, message:, text:, parameter_name:), &block)
      end

      def add_image_header(media_id: nil, link: nil, &block)
        add_header(Image.new(media_id:, link:), &block)
      end

      def add_document_header(media_id: nil, link: nil, filename: nil, &block)
        add_header(Document.new(media_id:, link:, filename:), &block)
      end

      def add_video_header(media_id: nil, link: nil, &block)
        add_header(Video.new(media_id:, link:), &block)
      end

      def add_location_header(latitude: nil, longitude: nil, address: nil, name: nil, &block)
        add_header(Location.new(latitude:, longitude:, address:, name:), &block)
      end

      def add_quick_reply_button(index: position, &block)
        add_button(Warb::Components::QuickReplyButton.new(index:), &block)
      end

      def add_dynamic_url_button(index: position, text: nil, &block)
        add_button(Warb::Components::UrlButton.new(index:, text:), &block)
      end

      alias add_auth_code_button add_dynamic_url_button

      def add_copy_code_button(index: position, coupon_code: nil, &block)
        add_button(Warb::Components::CopyCodeButton.new(index:, coupon_code:), &block)
      end

      def add_voice_call_button(index: position, &block)
        add_button(Warb::Components::VoiceCallButton.new(index:), &block)
      end

      def add_button(instance, &)
        return @buttons << instance.to_h unless block_given?

        @buttons << instance.tap(&).to_h
      end

      private

      def add_header(instance, &)
        @header = instance

        block_given? ? @header.tap(&) : @header
      end

      def component_header
        return unless header.is_a? Resource

        {
          type: 'header',
          parameters: [
            header.build_header
          ]
        }
      end

      def component_body
        return if resources.nil? || resources.empty?

        {
          type: 'body',
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

      def add_parameter(parameter_name, instance, &)
        case resources
        when Hash
          resources[parameter_name.to_s] = instance
        when Array
          resources << instance
        else
          initialize_resources(parameter_name, instance, &)
        end

        block_given? ? instance.tap(&) : instance
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

      def position
        buttons.count
      end
    end
  end
end
