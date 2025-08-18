# frozen_string_literal: true

FactoryBot.define do
  factory :audio, class: Warb::Resources::Audio do
    media_id { Faker::Number.numerify '################' }
    link { Faker::Internet.url }

    initialize_with { new(**attributes) }
  end
end
