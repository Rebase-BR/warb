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

    def reaction
      @reaction ||= Dispatcher.new Resources::Reaction, dispatcher
    end

    def indicator
      @indicator ||= IndicatorDispatcher.new dispatcher
    end

    private

    def dispatcher
      is_a?(Client) ? self : Warb.client
    end
  end
end
