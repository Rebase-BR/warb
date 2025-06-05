# frozen_string_literal: true

RSpec.describe Warb::Components::Row do
  describe "#to_h" do
    subject { build :row }

    it { expect(subject.to_h).to eq({ title: subject.title, description: subject.description }) }

    context "errors" do
      it do
        subject.title = "#" * 25
        subject.description = "#" * 73

        expect { subject.to_h }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to include(
            "Title length should be no longer than 24 characters",
            "Description length should be no longer than 72 characters"
          )
        end
      end

      it do
        subject.title = nil
        subject.description = nil

        expect { subject.to_h }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to include(
            "Title is required"
          )
        end
      end
    end
  end
end
