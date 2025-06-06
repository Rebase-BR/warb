# frozen_string_literal: true

FactoryBot.define do
  factory :address, class: Warb::Components::Address do
    type { %w[WORK HOME].sample }
    street { Faker::Address.street_name }
    city { Faker::Address.city }
    state { Faker::Address.state }
    zip { Faker::Address.zip_code }
    country { Faker::Address.country }
    country_code { Faker::Address.country_code }
  end
end
