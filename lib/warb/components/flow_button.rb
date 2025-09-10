# frozen_string_literal: true

module Warb
  module Components
    class FlowButton < Button
      BUTTON_TYPE = 'flow'

      attr_accessor :flow_token, :flow_action_data

      def to_h
        button_payload = super

        token = flow_token || @params[:flow_token]
        data  = flow_action_data || @params[:flow_action_data]

        action = {}
        action[:flow_token] = token if token
        action[:flow_action_data] = data if data

        button_payload[:parameters] = [{ type: 'action', action: action }]

        button_payload
      end

      private

      def button_type
        BUTTON_TYPE
      end
    end
  end
end
