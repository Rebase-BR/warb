# frozen_string_literal: true

FactoryBot.define do
  factory :name, class: Warb::Components::Name do
    formatted_name { Faker::Name.name }
    first_name { Faker::Name.first_name }
    last_name { Faker::Name.last_name }
    middle_name { Faker::Name.middle_name }
    suffix { Faker::Name.suffix }
    prefix { Faker::Name.prefix }
  end
end
