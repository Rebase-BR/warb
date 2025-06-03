# frozen_string_literal: true

FactoryBot.define do
  factory :cta, class: Warb::Resources::InteractiveCallToActionUrl do
    header { build(header_type).build_header }
    body { Faker::Lorem.sentence }
    footer { Faker::Lorem.sentence }
    action { build :cta_action }

    transient do
      header_type { %i[text image video document].sample }
    end

    initialize_with { new(**attributes) }
  end
end
