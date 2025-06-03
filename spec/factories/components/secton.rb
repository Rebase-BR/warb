# frozen_string_literal: true

FactoryBot.define do
  factory :section, class: Warb::Components::Section do
    title { Faker::Lorem.word }
    rows { build_list :row, rows_count }

    transient do
      rows_count { rand(1..3) }
    end

    initialize_with { new(**attributes) }
  end
end
