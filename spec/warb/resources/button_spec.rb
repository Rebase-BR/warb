# frozen_string_literal: true

RSpec.describe Warb::Components::Button do
  let(:button_resource) do
    build :button, index: 0, sub_type: "quick_reply"
  end

  describe "#to_h" do
    it "returns the correct payload structure" do
      expect(button_resource.to_h).to eq(
        {
          type: "button",
          sub_type: "quick_reply",
          index: 0
        }
      )
    end
  end
end
