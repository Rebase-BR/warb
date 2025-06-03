# frozen_string_literal: true

FactoryBot.define do
  factory :location_request, class: Warb::Resources::LocationRequest do
    body_text { Faker::Lorem.sentence }

    initialize_with { new(**attributes) }
  end
end
