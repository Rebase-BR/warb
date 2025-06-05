# frozen_string_literal: true

RSpec.describe Warb::Components::CTAAction do
  describe "#to_h" do
    let(:cta_action) { build :cta_action }

    subject { cta_action.to_h }

    it do
      is_expected.to eq(
        {
          name: "cta_url",
          parameters: {
            display_text: cta_action.button_text,
            url: cta_action.url
          }
        }
      )
    end

    context "errors" do
      subject { cta_action }

      it do
        subject.url = nil
        subject.button_text = nil

        expect { subject.to_h }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to include(
            "Button Text is required",
            "URL is required"
          )
        end
      end

      it do
        subject.button_text = "#" * 21

        expect { subject.to_h }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to include(
            "Button Text length should be no longer than 20 characters"
          )
        end
      end
    end
  end
end
