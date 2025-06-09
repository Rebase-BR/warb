# frozen_string_literal: true

RSpec.describe Warb::Resources::Location do
  let(:location_resource) do
    build :location, latitude: 0, longitude: 0, name: "Null Island", address: "Null Island"
  end

  describe "#build_header" do
    it do
      expect { location_resource.build_header }.to raise_error NotImplementedError
    end
  end

  describe "#build_payload" do
    subject { location_resource.build_payload }

    it do
      is_expected.to eq(
        {
          type: "location",
          location: {
            latitude: 0,
            longitude: 0,
            name: "Null Island",
            address: "Null Island"
          }
        }
      )
    end

    context "errors" do
      it do
        location = build(:location, latitude: nil, longitude: nil)

        expect { location.build_payload }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              latitude: :required,
              longitude: :required
            }
          )
        end
      end
    end
  end

  context "priorities" do
    subject { location_resource.build_payload[:location] }

    before do
      allow(location_resource).to receive_messages(
        {
          latitude: "latitude",
          longitude: "longitude",
          name: "name",
          address: "address"
        }
      )
    end

    it do
      is_expected.to eq(
        {
          latitude: "latitude",
          longitude: "longitude",
          name: "name",
          address: "address"
        }
      )
    end
  end
end
