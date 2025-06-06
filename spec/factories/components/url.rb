# frozen_string_literal: true

FactoryBot.define do
  factory :url, class: Warb::Components::URL do
    url { Faker::Internet.url }
    type { %w[HOME WORK].sample }
  end
end
