# frozen_string_literal: true

module Warb
  class Response
    attr_reader :input, :wa_id, :message_id, :raw

    def initialize(body)
      @raw        = body || {}
      @input      = @raw["contacts"]&.first&.dig("input")
      @wa_id      = @raw["contacts"]&.first&.dig("wa_id")
      @message_id = @raw["messages"]&.first&.dig("message_id")
    end
  end
end
