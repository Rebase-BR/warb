# frozen_string_literal: true

FactoryBot.define do
  factory :reply_button_action, class: Warb::Components::ReplyButtonAction do
    buttons_texts { Faker::Lorem.words number: buttons_count }

    transient do
      buttons_count { 3 }
    end

    initialize_with { new(**attributes) }
  end
end
