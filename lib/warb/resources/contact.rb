# frozen_string_literal: true

require_relative '../components/address'
require_relative '../components/name'
require_relative '../components/email'
require_relative '../components/org'
require_relative '../components/phone'
require_relative '../components/url'

module Warb
  module Resources
    class Contact < Resource
      attr_accessor :addresses, :emails, :phones, :urls, :name, :org, :birthday

      def initialize(**params)
        super

        @org = @params[:org]
        @name = @params[:name]
        @birthday = @params[:birthday]
        @addresses = @params.fetch(:addresses, [])
        @emails = @params.fetch(:emails, [])
        @phones = @params.fetch(:phones, [])
        @urls = @params.fetch(:urls, [])
      end

      # rubocop:disable Metrics/MethodLength
      def build_payload
        {
          type: 'contacts',
          contacts: [
            {
              birthday: birthday,
              org: org.to_h,
              name: name.to_h,
              urls: urls.map(&:to_h),
              emails: emails.map(&:to_h),
              phones: phones.map(&:to_h),
              addresses: addresses.map(&:to_h)
            }
          ]
        }
      end
      # rubocop:enable Metrics/MethodLength

      def add_address(**params, &)
        address = Components::Address.new(**params)

        @addresses << address

        block_given? ? address.tap(&) : address
      end

      def add_email(**params, &)
        email = Components::Email.new(**params)

        @emails << email

        block_given? ? email.tap(&) : email
      end

      def add_phone(**params, &)
        phone = Components::Phone.new(**params)

        @phones << phone

        block_given? ? phone.tap(&) : phone
      end

      def add_url(**params, &)
        url = Components::URL.new(**params)

        @urls << url

        block_given? ? url.tap(&) : url
      end

      def build_name(**params, &)
        @name = Warb::Components::Name.new(**params)

        block_given? ? @name.tap(&) : @name
      end

      def build_org(**params, &)
        @org = Warb::Components::Org.new(**params)

        block_given? ? @org.tap(&) : @org
      end
    end
  end
end
