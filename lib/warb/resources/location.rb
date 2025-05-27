# frozen_string_literal: true

module Warb
  module Resources
    class Location < Resource
      def build_payload
        {
          type: "location",
          location: {
            latitude: @params[:latitude],
            longitude: @params[:longitude],
            name: @params[:name],
            address: @params[:address]
          }
        }
      end
    end
  end
end
