# frozen_string_literal: true

module Warb
  module Resources
    class InteractiveMessageResource < Resource
      attr_accessor :header, :body, :footer, :action

      def initialize(**params)
        super(**params)

        @header = @params[:header]
        @body = @params[:body]
        @footer = @params[:footer]
      end

      protected

      def common_interactive_message_params(interactive_message_type, with_header: true, with_footer: true)
        { type: "interactive" }.tap do |params|
          params[:interactive] = {
            type: interactive_message_type.to_s,
            body: body_data,
            action: action_data
          }

          params[:interactive][:header] = header_data if with_header
          params[:interactive][:footer] = footer_data if with_footer
        end
      end

      private

      def header_data
        (header || @params[:header])&.to_h
      end

      def body_data
        {
          text: body || @params[:body]
        }
      end

      def footer_data
        {
          text: footer || @params[:footer]
        }
      end

      def action_data
        (action || @params[:action])&.to_h
      end

      def check_errors
        errors = {}

        check_header_errors(errors)
        check_body_errors(errors)
        check_footer_errors(errors)

        raise Warb::Error.new(errors: errors) unless errors.empty?
      end

      def check_header_errors(errors)
        return if header.nil?

        return errors[:header] = Error.cannot_be_empty if header.empty?
        return errors[:header_type] = Error.required if header[:type].nil? || header[:type].empty?

        check_header_data_errors(errors)
      end

      def check_header_data_errors(errors)
        return check_text_header_errors(errors) if header[:type] == "text"
        return check_media_header_errors(errors) if valid_media_header_types.include? header[:type]

        errors[:header_type] = Error.invalid_value
      end

      def check_text_header_errors(errors)
        return errors[:header_text] = Error.required if header[:text].nil?

        errors[:header_text] = Error.too_long(max_header_text_length) if header[:text].length > max_header_text_length
      end

      def check_media_header_errors(errors)
        media_type = header[:type].to_sym
        attr = "header_#{media_type}".to_sym
        link_attr = "#{attr}_link".to_sym

        return errors[attr] = Error.required if header[media_type].nil?
        return errors[link_attr] = Error.required if header[media_type][:link].nil?

        return if URI::DEFAULT_PARSER.make_regexp.match(header[media_type][:link])

        errors[link_attr] = Error.invalid_value
      end

      def check_body_errors(errors)
        return errors[:body] = Error.required if body.nil?

        errors[:body] = Error.too_long(max_body_text_length) if body.length > max_body_text_length
      end

      def check_footer_errors(errors)
        return if footer.nil?

        errors[:footer] = Error.too_long(max_footer_text_length) if footer.length > max_footer_text_length
      end

      def max_header_text_length
        60
      end

      def max_body_text_length
        4096
      end

      def max_footer_text_length
        60
      end

      def valid_media_header_types
        %w[image video document]
      end
    end
  end
end
