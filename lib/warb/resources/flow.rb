# frozen_string_literal: true

module Warb
  module Resources
    class Flow < Resource
      attr_accessor :flow_id, :screen, :flow_action, :mode,
                    :flow_cta, :flow_token, :body, :header, :footer, :data,
                    :draft, :data_exchange

      def build_payload
        validate!

        {
          type: 'interactive',
          interactive: build_interactive
        }
      end

      private

      def build_interactive
        interactive = {
          type: 'flow',
          action: {
            name: 'flow',
            parameters: build_action_parameters
          }
        }

        resolve(:header)
          .then { |header| interactive[:header] = header if header.is_a?(Hash) }

        resolve(:body)
          .then { |body| interactive[:body] = { text: body } }

        resolve(:footer)
          .then { |footer| interactive[:footer] = { text: footer } unless blank?(footer) }

        interactive
      end

      def build_action_parameters
        params = {
          flow_message_version: '3',
          flow_id: resolve(:flow_id),
          flow_action: final_action,
          mode: final_mode
        }

        resolve(:flow_cta)
          .then { |label| params[:flow_cta] = label unless blank?(label) }

        resolve(:flow_token)
          .then { |token| params[:flow_token] = token unless blank?(token) }

        if final_action == 'navigate'
          payload = { screen: resolve(:screen) }
          initial = resolve(:data)
          payload[:data] = initial unless blank?(initial)
          params[:flow_action_payload] = payload
        end

        params
      end

      def final_action
        explicit = raw_value(:flow_action)
        return explicit.to_s unless blank?(explicit)
        resolve(:data_exchange) ? 'data_exchange' : 'navigate'
      end

      def final_mode
        explicit = raw_value(:mode)
        return explicit.to_s unless blank?(explicit)
        resolve(:draft) ? 'draft' : 'published'
      end

      def validate!
        validates :flow_id, required: true
        validates :body,    required: true

        validates :screen,
                 required: -> { final_action == 'navigate' },
                 message:  'screen is required for flow_action=navigate'
      end
    end
  end
end
