# frozen_string_literal: true

RSpec.describe Warb::Resources::Button do
  let(:button_resource) do
    build :button, index: 0, sub_type: "quick_reply"
  end

  describe "#build_payload" do
    it "returns the correct payload structure" do
      expect(button_resource.build_payload).to eq(
        {
          type: "button",
          sub_type: "quick_reply",
          index: 0
        }
      )
    end
  end
end
