# frozen_string_literal: true

FactoryBot.define do
  factory :cta_action, class: Warb::Components::CTAAction do
    button_text { Faker::Lorem.word }
    url { Faker::Internet.url }

    initialize_with { new(**attributes) }
  end
end
