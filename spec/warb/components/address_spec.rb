# frozen_string_literal: true

RSpec.describe Warb::Components::Address do
  describe "#to_h" do
    let(:address) do
      described_class.new street: "work street", city: "work city", state: "work state", zip: "work zip",
                          country: "work country", country_code: "work country_code", type: "WORK"
    end

    subject { address.to_h }

    context "built from given params" do
      it do
        is_expected.to eq(
          {
            street: "work street",
            city: "work city",
            state: "work state",
            zip: "work zip",
            country: "work country",
            country_code: "work country_code",
            type: "WORK"
          }
        )
      end
    end

    context "overwriting some values" do
      before do
        address.street = "home street"
        address.city = "home city"
        address.state = "home state"
        address.zip = "home zip"
        address.type = "HOME"
      end

      it do
        is_expected.to eq(
          {
            street: "home street",
            city: "home city",
            state: "home state",
            zip: "home zip",
            type: "HOME",
            country: "work country",
            country_code: "work country_code"
          }
        )
      end
    end
  end
end
