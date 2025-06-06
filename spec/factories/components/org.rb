# frozen_string_literal: true

FactoryBot.define do
  factory :org, class: Warb::Components::Org do
    company { Faker::Company.name }
    department { Faker::Company.department }
    title { Faker::Job.title }
  end
end
