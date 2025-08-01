# frozen_string_literal: true

RSpec.describe Warb::Components::UrlButton do
  let(:url_button_resource) do
    build :url_button, index: 0, text: "/example"
  end

  describe "#to_h" do
    it "returns the correct payload structure with parameters" do
      expect(url_button_resource.to_h).to eq(
        {
          type: "button",
          sub_type: "url",
          index: 0,
          parameters: [
            {
              type: "text",
              text: "/example"
            }
          ]
        }
      )
    end

    context "when text is nil" do
      let(:url_button_resource) do
        build :url_button, index: 0, text: nil
      end

      it "returns payload without parameters" do
        expect(url_button_resource.to_h).to eq(
          {
            type: "button",
            sub_type: "url",
            index: 0
          }
        )
      end
    end
  end
end
