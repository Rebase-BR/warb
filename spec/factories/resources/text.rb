# frozen_string_literal: true

FactoryBot.define do
  factory :text, class: Warb::Resources::Text do
    content { Faker::Lorem.sentence }
    preview_url { [nil, false, true].sample }

    initialize_with { new(**attributes) }
  end
end
