# frozen_string_literal: true

RSpec.describe Warb::Components::Button do
  describe "#to_h" do
    let(:button) { build :button, index: 0, sub_type: "quick_reply" }

    it "returns the correct payload structure" do
      expect(button.to_h).to eq(
        {
          type: "button",
          sub_type: "quick_reply",
          index: 0
        }
      )
    end
  end

  describe "#initialize" do
    context "when sub_type is provided" do
      let(:button) { Warb::Components::Button.new(index: 0, sub_type: "quick_reply") }

      it "uses the provided sub_type" do
        expect(button.to_h[:sub_type]).to eq("quick_reply")
      end

      it "does not call button_type method" do
        allow(button).to receive(:button_type).and_call_original

        expect(button).not_to have_received(:button_type)
      end
    end

    context "when sub_type is not provided" do
      it "raises NotImplementedError when trying to use button_type" do
        expect { Warb::Components::Button.new(index: 0) }.to raise_error(NotImplementedError)
      end
    end
  end
end
