# frozen_string_literal: true

FactoryBot.define do
  factory :warb_config, class: Warb::Configuration do
    access_token { Faker::Internet.device_token }
    sender_id { Faker::Number.numerify("#" * 15) }
    business_id { Faker::Number.numerify("#" * 16) }
    adapter { :net_http }
    logger { nil }

    initialize_with { new(**attributes) }
  end
end
