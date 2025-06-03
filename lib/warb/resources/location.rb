# frozen_string_literal: true

module Warb
  module Resources
    class Location < Resource
      attr_accessor :latitude, :longitude, :name, :address

      def build_payload
        {
          type: "location",
          location: {
            latitude: latitude || @params[:latitude],
            longitude: longitude || @params[:longitude],
            name: name || @params[:name],
            address: address || @params[:address]
          }
        }
      end
    end
  end
end
