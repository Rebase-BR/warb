# frozen_string_literal: true

FactoryBot.define do
  factory :document, class: Warb::Resources::Document do
    media_id { Faker::Number.numerify "################" }
    link { Faker::Internet.url }
    caption { Faker::Lorem.sentence }
    filename { Faker::File.file_name }

    initialize_with { new(**attributes) }
  end
end
