# frozen_string_literal: true

FactoryBot.define do
  factory :email, class: Warb::Components::Email do
    type { %w[WORK HOME].sample }
    email { Faker::Internet.email }
  end
end
