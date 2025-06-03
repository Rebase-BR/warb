# frozen_string_literal: true

FactoryBot.define do
  factory :interactive_list_action, class: Warb::Components::ListAction do
    button_text { Faker::Lorem.word }
    sections { build_list :section, sections_count }

    transient do
      sections_count { rand(1..10) }
    end

    initialize_with { new(**attributes) }
  end
end
