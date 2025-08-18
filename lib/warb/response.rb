# frozen_string_literal: true

module Warb
  class Response
    attr_reader :input, :wa_id, :message_id, :body

    def initialize(body)
      @body = body || {}
      extract_contact_data
      extract_message_data
    end

    private

    def extract_contact_data
      first_contact = contacts&.first
      @input = first_contact&.dig('input')
      @wa_id = first_contact&.dig('wa_id')
    end

    def extract_message_data
      @message_id = messages&.first&.dig('id')
    end

    def contacts
      @body['contacts']
    end

    def messages
      @body['messages']
    end
  end
end
