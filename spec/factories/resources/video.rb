# frozen_string_literal: true

FactoryBot.define do
  factory :video, class: Warb::Resources::Video do
    media_id { Faker::Number.numerify "################" }
    link { Faker::Internet.url }
    caption { Faker::Lorem.sentence }

    initialize_with { new(**attributes) }
  end
end
