# frozen_string_literal: true

FactoryBot.define do
  factory :copy_code_button, class: Warb::Components::CopyCodeButton do
    index { rand(0..3) }
    sub_type { 'copy_code' }
    coupon_code { Faker::Alphanumeric.alphanumeric(number: 8).upcase }

    initialize_with { new(**attributes) }
  end
end
