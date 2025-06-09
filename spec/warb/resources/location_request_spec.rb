# frozen_string_literal: true

RSpec.describe Warb::Resources::LocationRequest do
  let(:location_request_resource) do
    build :location_request, body: "Share your location, please?"
  end

  describe "#build_header" do
    it do
      expect { location_request_resource.build_header }.to raise_error NotImplementedError
    end
  end

  describe "#build_payload" do
    subject { location_request_resource.build_payload }

    it do
      is_expected.to eq(
        {
          type: "interactive",
          interactive: {
            type: "location_request_message",
            body: {
              text: "Share your location, please?"
            },
            action: {
              name: "send_location"
            }
          }
        }
      )
    end
  end

  context "errors" do
    it do
      location_request_resource.body = "#" * 1025

      expect { location_request_resource.build_payload }.to raise_error(Warb::Error) do |error|
        expect(error.errors).to eq(
          {
            body: :no_longer_than_1024_characters
          }
        )
      end
    end
  end

  context "priorities" do
    subject { location_request_resource.build_payload }

    before do
      allow(location_request_resource).to receive_messages(
        {
          body: "Send your location"
        }
      )
    end

    it do
      is_expected.to eq(
        {
          type: "interactive",
          interactive: {
            type: "location_request_message",
            body: {
              text: "Send your location"
            },
            action: {
              name: "send_location"
            }
          }
        }
      )
    end
  end
end
