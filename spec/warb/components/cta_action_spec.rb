# frozen_string_literal: true

RSpec.describe Warb::Components::CTAAction do
  describe '#to_h' do
    subject { cta_action.to_h }

    let(:cta_action) { build :cta_action }

    it do
      expect(subject).to eq(
        {
          name: 'cta_url',
          parameters: {
            display_text: cta_action.button_text,
            url: cta_action.url
          }
        }
      )
    end
  end
end
