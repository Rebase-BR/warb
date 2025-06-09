# frozen_string_literal: true

require "unicode/emoji"

module Warb
  module Resources
    class Reaction < Resource
      attr_accessor :message_id, :emoji

      def initialize(**params)
        super(**params)

        @message_id = @params[:message_id]
        @emoji = @params[:emoji]
      end

      def build_payload
        check_errors

        {
          type: "reaction",
          reaction: {
            message_id: message_id || @params[:message_id],
            emoji: emoji || @params[:emoji]
          }
        }
      end

      private

      def check_errors
        errors = {}

        check_message_id_errors(errors)
        check_emoji_errors(errors)

        raise Warb::Error.new(errors: errors) unless errors.empty?
      end

      def check_message_id_errors(errors)
        errors[:message_id] = Error.required if message_id.nil? || message_id.strip.empty?
      end

      def check_emoji_errors(errors)
        return errors[:emoji] = Error.required if emoji.nil?

        errors[:emoji] = Error.invalid_value unless valid_reaction_emoji?(emoji)
      end

      def valid_reaction_emoji?(emoji)
        empty?(emoji) || single_rendered_emoji?(emoji) || valid_escaped_surrogate_pair?(emoji)
      end

      def empty?(emoji)
        emoji == ""
      end

      def single_rendered_emoji?(emoji)
        emoji.scan(Unicode::Emoji::REGEX).length == 1
      end

      def valid_escaped_surrogate_pair?(emoji)
        return false unless emoji.match?(/\A(\\u[0-9A-Fa-f]{4})+\z/)

        rendered = emoji.gsub(/\\u([0-9A-Fa-f]{4})/) { [Regexp.last_match(1).hex].pack("U") }

        Unicode::Emoji.emoji?(rendered) && rendered.scan(Unicode::Emoji::REGEX).length == 1
      rescue StandardError
        false
      end
    end
  end
end
