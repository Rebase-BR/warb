# frozen_string_literal: true

module Warb
  module Components
    class Address
      attr_accessor :street, :city, :state, :zip, :country, :country_code, :type

      def initialize(**params)
        @street = params[:street]
        @city = params[:city]
        @state = params[:state]
        @zip = params[:zip]
        @country = params[:country]
        @country_code = params[:country_code]
        @type = params[:type]
      end

      def to_h
        {
          street: street,
          city: city,
          state: state,
          zip: zip,
          country: country,
          country_code: country_code,
          type: type
        }
      end
    end
  end
end
