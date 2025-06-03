# frozen_string_literal: true

FactoryBot.define do
  factory :location, class: Warb::Resources::Location do
    latitude { Faker::Address.latitude }
    longitude { Faker::Address.longitude }
    name { Faker::Address.street_name }
    address { Faker::Address.street_address }

    initialize_with { new(**attributes) }
  end
end
