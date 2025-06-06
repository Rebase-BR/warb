# frozen_string_literal: true

FactoryBot.define do
  factory :phone, class: Warb::Components::Phone do
    phone { Faker::PhoneNumber.phone_number_with_country_code }
    type { %w[HOME WORK].sample }
    wa_id { Faker::PhoneNumber.phone_number }
  end
end
