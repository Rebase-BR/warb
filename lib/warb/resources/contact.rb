# frozen_string_literal: true

require_relative "../components/address"
require_relative "../components/name"
require_relative "../components/email"
require_relative "../components/org"
require_relative "../components/phone"
require_relative "../components/url"

module Warb
  module Resources
    class Contact < Resource
      attr_accessor :addresses, :emails, :phones, :urls, :name, :org, :birthday

      def initialize(**params)
        super(**params)

        @org = @params[:org]
        @name = @params[:name]
        @birthday = @params[:birthday]
        @addresses = @params.fetch(:addresses, [])
        @emails = @params.fetch(:emails, [])
        @phones = @params.fetch(:phones, [])
        @urls = @params.fetch(:urls, [])
      end

      def build_payload
        {
          type: "contacts",
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

      def add_address(**params, &block)
        address = Components::Address.new(**params)

        @addresses << address

        block_given? ? address.tap(&block) : address
      end

      def add_email(**params, &block)
        email = Components::Email.new(**params)

        @emails << email

        block_given? ? email.tap(&block) : email
      end

      def add_phone(**params, &block)
        phone = Components::Phone.new(**params)

        @phones << phone

        block_given? ? phone.tap(&block) : phone
      end

      def add_url(**params, &block)
        url = Components::URL.new(**params)

        @urls << url

        block_given? ? url.tap(&block) : url
      end

      def build_name(**params, &block)
        @name = Warb::Components::Name.new(**params)

        block_given? ? @name.tap(&block) : @name
      end

      def build_org(**params, &block)
        @org = Warb::Components::Org.new(**params)

        block_given? ? @org.tap(&block) : @org
      end
    end
  end
end
