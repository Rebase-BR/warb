# frozen_string_literal: true

FactoryBot.define do
  factory :row, class: Warb::Components::Row do
    title { Faker::Lorem.word }
    description { Faker::Lorem.sentence }

    initialize_with { new(**attributes) }
  end
end
