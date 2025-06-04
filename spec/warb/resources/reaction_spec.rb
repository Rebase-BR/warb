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
  end
end
