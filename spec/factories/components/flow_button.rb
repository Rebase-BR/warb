# frozen_string_literal: true

FactoryBot.define do
  factory :flow_button, class: Warb::Components::FlowButton do
    index { rand(0..3) }
    sub_type { 'flow' }
    flow_token { nil }
    flow_action_data { nil }

    initialize_with { new(**attributes) }

    trait :with_token do
      flow_token { 'TOKEN_123' }
    end

    trait :with_action_data do
      flow_action_data { { nome: 'Ana', cpf: '11122233344' } }
    end

    trait :complete do
      flow_token { 'TOKEN_ABC' }
      flow_action_data { { foo: 'bar' } }
    end
  end
end
