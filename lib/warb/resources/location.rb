# frozen_string_literal: true

module Warb
  module Resources
    class Location < Resource
      attr_accessor :latitude, :longitude, :name, :address

      def build_header
        common_location_params
      end

      def build_payload
        common_location_params
      end

      private

      def common_location_params
        {
          type: 'location',
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
