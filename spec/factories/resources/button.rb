# frozen_string_literal: true

FactoryBot.define do
  factory :button, class: Warb::Resources::Button do
    index { rand(0..3) }
    sub_type { %w[quick_reply url copy_code voice_call].sample }

    initialize_with { new(**attributes) }
  end
end
