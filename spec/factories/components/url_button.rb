# frozen_string_literal: true

FactoryBot.define do
  factory :url_button, class: Warb::Components::UrlButton do
    index { rand(0..3) }
    sub_type { "url" }
    text { Faker::Internet.slug }

    initialize_with { new(**attributes) }
  end
end
