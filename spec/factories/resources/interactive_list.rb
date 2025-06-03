# frozen_string_literal: true

FactoryBot.define do
  factory :interactive_list, class: Warb::Resources::InteractiveList do
    header { build(:text).build_header }
    body { Faker::Lorem.word }
    footer { Faker::Lorem.word }
    action { build(:interactive_list_action) }

    initialize_with { new(**attributes) }
  end
end
