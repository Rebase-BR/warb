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
