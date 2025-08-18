# frozen_string_literal: true

module Warb
  module DispatcherConcern
    def message
      @message ||= Dispatcher.new Resources::Text, dispatcher
    end

    def image
      @image ||= MediaDispatcher.new Resources::Image, dispatcher
    end

    def video
      @video ||= MediaDispatcher.new Resources::Video, dispatcher
    end

    def audio
      @audio ||= MediaDispatcher.new Resources::Audio, dispatcher
    end

    def document
      @document ||= MediaDispatcher.new Resources::Document, dispatcher
    end

    def location
      @location ||= Dispatcher.new Resources::Location, dispatcher
    end

    def location_request
      @location_request ||= Dispatcher.new Resources::LocationRequest, dispatcher
    end

    def interactive_reply_button
      @interactive_reply_button ||= Dispatcher.new Resources::InteractiveReplyButton, dispatcher
    end

    def interactive_list
      @interactive_list ||= Dispatcher.new Resources::InteractiveList, dispatcher
    end

    def interactive_call_to_action_url
      @interactive_call_to_action_url ||= Dispatcher.new Resources::InteractiveCallToActionUrl, dispatcher
    end

    def sticker
      @sticker ||= MediaDispatcher.new Resources::Sticker, dispatcher
    end

    def reaction
      @reaction ||= Dispatcher.new Resources::Reaction, dispatcher
    end

    def indicator
      @indicator ||= IndicatorDispatcher.new dispatcher
    end

    def contact
      @contact ||= Dispatcher.new Resources::Contact, dispatcher
    end

    def template
      @template ||= TemplateDispatcher.new Resources::Template, dispatcher
    end

    def flow
      @flow ||= Dispatcher.new Resources::Flow, dispatcher
    end

    private

    def dispatcher
      is_a?(Client) ? self : Warb.client
    end
  end
end
