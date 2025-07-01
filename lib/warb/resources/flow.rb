# frozen_string_literal: true

module Warb
  module Resources
    class Flow < Resource
      attr_accessor :flow_id, :screen

      def build_payload
        {
          type: "interactive",
          interactive: {
            type: "flow",
            body: {
              text: "Not shown in draft mode"
            },
            action: {
              name: "flow",
              parameters: {
                flow_message_version: "3",
                flow_action: "navigate",
                flow_id: flow_id || @params[:flow_id],
                flow_cta: "Not shown in draft mode",
                mode: "draft",
                flow_action_payload: {
                  screen: screen || @params[:screen]
                }
              }
            }
          }
        }
      end
    end
  end
end
