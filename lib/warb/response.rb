# frozen_string_literal: true

module Warb
  class Response
    attr_reader :input, :wa_id, :message_id, :body

    def initialize(body)
      @body        = body || {}
      @input      = @body["contacts"]&.first&.dig("input")
      @wa_id      = @body["contacts"]&.first&.dig("wa_id")
      @message_id = @body["messages"]&.first&.dig("id")
    end
  end
end
