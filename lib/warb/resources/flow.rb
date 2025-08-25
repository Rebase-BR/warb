# frozen_string_literal: true

module Warb
  module Resources
    class Flow < Resource
      attr_accessor :flow_id, :screen, :flow_action, :mode,
                    :flow_cta, :flow_token, :body, :header, :footer, :data

      def build_payload
        validate!

        {
          type: "interactive",
          interactive: build_interactive
        }
      end

      private

      def build_interactive
        interactive = {
          type: "flow",
          action: {
            name: "flow",
            parameters: build_action_parameters
          }
        }

        header = resolve(:header)
        interactive[:header] = header if header.is_a?(Hash)

        body = resolve(:body)
        interactive[:body] = { text: body }

        footer = resolve(:footer)
        interactive[:footer] = { text: footer } unless blank?(footer)

        interactive
      end

      def build_action_parameters
        action = resolve(:flow_action, "navigate").to_s
        mode    = resolve(:mode, "published").to_s

        params = {
          flow_message_version: "3",
          flow_id: resolve(:flow_id),
          flow_action: action,
          mode: mode
        }

        label = resolve(:flow_cta)
        params[:flow_cta] = label unless blank?(label)

        token = resolve(:flow_token)
        params[:flow_token] = token unless blank?(token)

        if action == "navigate"
          payload = { screen: resolve(:screen) }
          initial = resolve(:data)
          payload[:data] = initial unless blank?(initial)
          params[:flow_action_payload] = payload
        end

        params
      end

      def validate!
        raise ArgumentError, "flow_id is required" if blank?(resolve(:flow_id))
        raise ArgumentError, "body is required for flow message" if blank?(resolve(:body))

        if resolve(:flow_action, "navigate").to_s == "navigate" && blank?(resolve(:screen))
          raise ArgumentError, "screen is required for flow_action=navigate"
        end
      end

      def resolve(name, default = nil)
        val = send(name)
        val = @params[name] if blank?(val) && @params&.key?(name)
        val = default if blank?(val) && !default.nil?
        val
      end

      def blank?(val)
        val.respond_to?(:empty?) ? val.empty? : !val
      end
    end
  end
end
