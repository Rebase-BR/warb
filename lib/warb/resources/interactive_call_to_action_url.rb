# frozen_string_literal: true

module Warb
  module Resources
    class InteractiveCallToActionUrl < InteractiveMessageResource
      def build_payload
        check_errors

        common_interactive_message_params(:cta_url)
      end

      def set_text_header(text)
        @header = Warb::Resources::Text.new(text:).build_header
      end

      def set_image_header(link: nil)
        @header = Warb::Resources::Image.new(link:).build_header
      end

      def set_video_header(link: nil)
        @header = Warb::Resources::Video.new(link:).build_header
      end

      def set_document_header(link: nil, filename: nil)
        @header = Warb::Resources::Document.new(link:, filename:).build_header
      end

      def build_action(&block)
        @action = Warb::Components::CTAAction.new

        block_given? ? @action.tap(&block) : @action
      end

      private

      def check_errors
        errors = []

        check_header_errors(errors)

        raise Warb::Error.new(errors: errors) unless errors.empty?
      end

      def check_header_errors(errors)
        return if header.nil?

        return errors << "Header cannot be empty" if header.empty?
        return errors << "Header Type is required" if header[:type].nil? || header[:type].empty?

        check_header_data_errors(errors)
      end

      def check_header_data_errors(errors)
        return check_text_header_errors(errors) if header[:type] == "text"
        return check_media_header_errors(errors) if %w[image video document].include? header[:type]

        errors << "#{header[:type]} is not a valid value for Header Type"
      end

      def check_text_header_errors(errors)
        return errors << "Header Text is required" if header[:text].nil?

        errors << "Header Text length should be no longer than 60 characters" if header[:text].length > 60
      end

      def check_media_header_errors(errors)
        media_type = header[:type].to_sym
        attr = media_type.to_s.capitalize

        return errors << "Header #{attr} is required" if header[media_type].nil?
        return errors << "Header #{attr} Link is required" if header[media_type][:link].nil?

        return if URI::DEFAULT_PARSER.make_regexp.match(header[media_type][:link])

        errors << "Header #{attr} Link must be a valid URL"
      end
    end
  end
end
