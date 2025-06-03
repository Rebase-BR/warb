# frozen_string_literal: true

FactoryBot.define do
  factory :reply_button, class: Warb::Resources::InteractiveReplyButton do
    header { build(header_type).build_header }
    body { Faker::Lorem.sentence }
    footer { Faker::Lorem.sentence }
    action { build :reply_button_action }

    transient do
      header_type { %i[text image video document].sample }
    end

    initialize_with { new(**attributes) }
  end
end
