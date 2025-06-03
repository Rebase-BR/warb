# frozen_string_literal: true

FactoryBot.define do
  factory :row, class: Warb::Components::Row do
    title { Faker::Lorem.word }
    description { Faker::Lorem.paragraph }

    initialize_with { new(**attributes) }
  end
end
