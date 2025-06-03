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
  end
end
