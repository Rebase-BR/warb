# frozen_string_literal: true

RSpec.describe Warb::Resources::Reaction do
  describe "#build_payload" do
    subject { described_class.new message_id: "message_id", emoji: "👍" }

    it do
      expect(subject.build_payload).to eq(
        {
          type: "reaction",
          reaction: {
            message_id: "message_id",
            emoji: "👍"
          }
        }
      )
    end

    context "errors" do
      it do
        emoji = described_class.new message_id: nil, emoji: nil

        expect { emoji.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              message_id: :required,
              emoji: :required
            }
          )
        end
      end

      it do
        emoji = described_class.new message_id: "", emoji: ""

        expect { emoji.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              message_id: :required
            }
          )
        end
      end

      it do
        emoji = described_class.new message_id: " ", emoji: "U+1F600"

        expect { emoji.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              message_id: :required,
              emoji: :invalid_value
            }
          )
        end
      end

      it do
        emoji = described_class.new message_id: "message_id", emoji: "\\u0041"

        expect { emoji.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              emoji: :invalid_value
            }
          )
        end
      end
    end
  end
end
