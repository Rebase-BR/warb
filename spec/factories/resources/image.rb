# frozen_string_literal: true

FactoryBot.define do
  factory :image, class: Warb::Resources::Image do
    media_id { Faker::Number.numerify '################' }
    link { Faker::Internet.url }
    caption { Faker::Lorem.sentence }

    initialize_with { new(**attributes) }
  end
end
