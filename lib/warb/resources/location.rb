# frozen_string_literal: true

module Warb
  module Resources
    class Location < Resource
      attr_accessor :latitude, :longitude, :name, :address

      def build_payload
        check_errors

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

      private

      def check_errors
        errors = {}

        errors[:latitude] = Error.required if latitude.nil? && @params[:latitude].nil?
        errors[:longitude] = Error.required if longitude.nil? && @params[:longitude].nil?

        raise Warb::Error.new(errors: errors) unless errors.empty?
      end
    end
  end
end
