# frozen_string_literal: true

RSpec.describe Warb::Client do
  before do
    Warb.instance_variable_set(:@configuration, nil)
    Warb.instance_variable_set(:@client, nil)
  end

  describe ".new" do
    before { allow(Warb::Configuration).to receive(:new).and_call_original }

    context "with an existing configuration" do
      let(:configuration) { build :warb_config }

      before do
        allow(Warb::Client).to receive(:new).and_call_original
        allow(Warb::Configuration).to receive(:new).and_return(configuration)

        Warb.configuration
      end

      context "using the existing values" do
        it do
          expect(Warb::Configuration).not_to receive(:new)

          client = described_class.new

          expect(client.access_token).to eq configuration.access_token
          expect(client.sender_id).to eq configuration.sender_id
          expect(client.business_id).to eq configuration.business_id
          expect(client.adapter).to eq configuration.adapter
          expect(client.logger).to eq configuration.logger
        end
      end

      context "overwriting some values" do
        it do
          configuration_copy = Warb.configuration.dup

          expect(Warb::Configuration).not_to receive(:new)

          client = described_class.new access_token: "access_token",
                                       sender_id: "sender_id", business_id: "business_id"

          expect(client.access_token).not_to eq configuration.access_token
          expect(client.access_token).to eq "access_token"
          expect(client.sender_id).not_to eq configuration.sender_id
          expect(client.sender_id).to eq "sender_id"
          expect(client.business_id).not_to eq configuration.business_id
          expect(client.business_id).to eq "business_id"
          expect(client.adapter).to eq configuration.adapter
          expect(client.logger).to eq configuration.logger
          expect(configuration_copy.access_token).to eq configuration.access_token
          expect(configuration_copy.sender_id).to eq configuration.sender_id
          expect(configuration_copy.business_id).to eq configuration.business_id
        end
      end

      context "overwriting some values, without affecting the original configuration" do
        it do
          configuration_copy = Warb.configuration.dup

          expect(Warb::Configuration).not_to receive(:new)

          client = described_class.new configuration, access_token: "access_token",
                                                      sender_id: "sender_id", business_id: "business_id"

          expect(client.access_token).not_to eq configuration.access_token
          expect(client.access_token).to eq "access_token"
          expect(client.sender_id).not_to eq configuration.sender_id
          expect(client.sender_id).to eq "sender_id"
          expect(client.business_id).not_to eq configuration.business_id
          expect(client.business_id).to eq "business_id"
          expect(client.adapter).to eq configuration.adapter
          expect(client.logger).to eq configuration.logger
          expect(configuration_copy.access_token).to eq configuration.access_token
          expect(configuration_copy.sender_id).to eq configuration.sender_id
          expect(configuration_copy.business_id).to eq configuration.business_id
        end
      end
    end

    context "without an existing configuration" do
      it do
        expect(Warb::Configuration).to receive(:new)

        described_class.new
      end
    end
  end

  context "connection" do
    subject { described_class.new }

    before do
      allow(Warb::Connection).to receive(:new).and_call_original
      allow_any_instance_of(Faraday::Connection).to receive(:send).and_return(nil)
    end

    describe "#get" do
      context "being the first connection" do
        it do
          expect(Warb::Connection).to receive(:new)
          expect_any_instance_of(Faraday::Connection).to receive(:send).with("get", "/endpoint", {}, {})

          subject.get("endpoint")
        end
      end

      context "not being the first connection" do
        before { subject.get("endpoint") }

        it do
          expect(Warb::Connection).not_to receive(:new)
          expect_any_instance_of(Faraday::Connection).to receive(:send).with("get", "/endpoint", { media_id: "id" }, {})

          subject.get("endpoint", { media_id: "id" })
        end
      end
    end

    describe "#post" do
      context "being the first connection" do
        it do
          expect(Warb::Connection).to receive(:new)
          expect_any_instance_of(Faraday::Connection).to receive(:send).with("post", "/endpoint", {}, {})

          subject.post("endpoint")
        end
      end

      context "not being the first connection" do
        before { subject.post("endpoint") }

        it do
          expect(Warb::Connection).not_to receive(:new)
          expect_any_instance_of(Faraday::Connection).to receive(:send).with("post", "/endpoint", { media_id: "id" }, {})

          subject.post("endpoint", { media_id: "id" })
        end
      end
    end

    describe "#put" do
      context "being the first connection" do
        it do
          expect(Warb::Connection).to receive(:new)
          expect_any_instance_of(Faraday::Connection).to receive(:send).with("put", "/endpoint", {}, {})

          subject.put("endpoint")
        end
      end

      context "not being the first connection" do
        before { subject.put("endpoint") }

        it do
          expect(Warb::Connection).not_to receive(:new)
          expect_any_instance_of(Faraday::Connection).to receive(:send).with("put", "/endpoint", { media_id: "id" }, {})

          subject.put("endpoint", { media_id: "id" })
        end
      end
    end

    describe "#delete" do
      context "being the first connection" do
        it do
          expect(Warb::Connection).to receive(:new)
          expect_any_instance_of(Faraday::Connection).to receive(:send).with("delete", "/endpoint", {}, {})

          subject.delete("endpoint")
        end
      end

      context "not being the first connection" do
        before { subject.delete("endpoint") }

        it do
          expect(Warb::Connection).not_to receive(:new)
          expect_any_instance_of(Faraday::Connection).to receive(:send).with("delete", "/endpoint", { media_id: "id" }, {})

          subject.delete("endpoint", { media_id: "id" })
        end
      end
    end
  end
end
