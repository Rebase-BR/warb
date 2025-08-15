# frozen_string_literal: true

FactoryBot.define do
  factory :flow, class: Warb::Resources::Flow do
    flow_id { Faker::Number.numerify '#######' }
    screen { Faker::App.name }
  end
end
