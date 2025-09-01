# frozen_string_literal: true

FactoryBot.define do
  factory :flow, class: Warb::Resources::Flow do
    flow_id { Faker::Number.numerify '#######' }
    screen  { Faker::App.name }
    body    { Faker::Lorem.sentence }

    trait :with_initial_data do
      data do
        {
          prefill: {
            name: Faker::Name.name,
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

      after(:build) do |flow, evaluator|
        case evaluator.header_type
        when :text
          flow.add_text_header(text: Faker::Lorem.sentence)

        when :image
          if evaluator.use_id
            flow.add_image_header(media_id: Faker::Number.number(digits: 16).to_s)
          else
            flow.add_image_header(link: Faker::Internet.url)
          end

        when :video
          if evaluator.use_id
            flow.add_video_header(media_id: Faker::Number.number(digits: 16).to_s)
          else
            flow.add_video_header(link: Faker::Internet.url)
          end

        when :document
          if evaluator.use_id
            flow.add_document_header(media_id: Faker::Number.number(digits: 16).to_s, filename: nil)
          else
            flow.add_document_header(
              link: Faker::Internet.url,
              filename: "doc_#{SecureRandom.hex(4)}.pdf"
            )
          end
        end
      end
    end

    trait :complete_structure do
      with_header
      footer { Faker::Lorem.sentence }
      flow_cta { Faker::Lorem.word }
      flow_token { Faker::Alphanumeric.alphanumeric }
    end
  end
end
