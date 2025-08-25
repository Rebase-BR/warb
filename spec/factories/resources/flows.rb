# frozen_string_literal: true

FactoryBot.define do
  factory :flow, class: Warb::Resources::Flow do
    flow_id { Faker::Number.numerify '#######' }
    screen  { Faker::App.name }
    body    { Faker::Lorem.sentence }

    trait :dynamic do
      flow_action { 'data_exchange' }
    end

    trait :with_initial_data do
      data do
        {
          prefill: {
            name:  Faker::Name.name,
            email: Faker::Internet.email
          }
        }
      end
    end

    trait :with_header do
      transient do
        header_type { %i[text image video document].sample }
        use_id      { [true, false].sample }
      end

      header do
        case header_type
        when :text
          { type: "text", text: Faker::Lorem.sentence }

        when :image
          media = use_id ? { id: Faker::Number.number(digits: 16).to_s } : { link: Faker::Internet.url }
          { type: "image", image: media }

        when :video
          media = use_id ? { id: Faker::Number.number(digits: 16).to_s } : { link: Faker::Internet.url }
          { type: "video", video: media }

        when :document
          if use_id
            { type: "document", document: { id: Faker::Number.number(digits: 16).to_s } }
          else
            filename = "doc_#{SecureRandom.hex(4)}.pdf"
            { type: "document", document: { link: Faker::Internet.url, filename: filename } }
          end
        end
      end
    end

    trait :complete_structure do
      with_header
      footer { Faker::Lorem.sentence }
    end
  end
end
