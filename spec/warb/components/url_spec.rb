# frozen_string_literal: true

RSpec.describe Warb::Components::URL do
  describe "#to_h" do
    let(:url) { described_class.new url: "url", type: "WORK" }

    subject { url.to_h }

    context "built from given params" do
      it do
        is_expected.to eq(
          {
            type: "WORK",
            url: "url"
          }
        )
      end
    end

    context "overwriting some values" do
      before do
        url.type = "HOME"
      end

      it do
        is_expected.to eq(
          {
            type: "HOME",
            url: "url"
          }
        )
      end
    end
  end
end
