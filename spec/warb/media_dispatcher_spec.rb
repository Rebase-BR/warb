# frozen_string_literal: true

RSpec.describe Warb::MediaDispatcher do
  let(:resource) { double("MediaResource", call: {}) }
  let(:client) { Warb.client }

  before do
    stub_const("MediaResource", new: resource)
  end

  subject { described_class.new MediaResource, client }

  describe "#upload" do
    let(:file_path) { "spec/warb/media_dispatcher_spec.rb" }
    let(:file_type) { "text/plain" }
    let(:file) { Faraday::UploadIO.new(file_path, file_type) }
    let(:data) { { file:, messaging_product: "whatsapp" } }
    let(:response) { instance_double("Net::HTTPOK", body: { id: "media_id" }) }

    before { allow(Faraday::UploadIO).to receive(:new).and_return(file) }

    it do
      expect(client).to receive(:post).with("media", data, multipart: true).and_return(response)

      subject.upload(file_path:, file_type:)
    end
  end

  describe "#download" do
    let(:response) { instance_double(Net::HTTPOK, body: "file binary data") }

    before do
      http = instance_double(Net::HTTP, request: response)
      allow(Net::HTTP).to receive(:start).and_yield(http)
    end

    after { File.unlink("downloaded_file") if File.exist?("downloaded_file") }

    it do
      expect(File).not_to exist("downloaded_file")

      subject.download file_path: "downloaded_file", media_url: "http://example.com/file.bin"

      expect(File).to exist("downloaded_file")
      expect(File.read("downloaded_file")).to eq "file binary data"
    end
  end

  describe "#retrieve" do
    let(:response) { instance_double("Faraday::Response", body: {}) }

    before do
      allow_any_instance_of(Faraday::Connection).to receive(:get).and_return(response)
    end

    it do
      expect(client).to receive(:get).and_call_original

      subject.retrieve "media_id"
    end
  end

  describe "#delete" do
    before do
      allow_any_instance_of(Faraday::Connection).to receive(:delete).and_return(response)
    end

    context "success" do
      let(:response) { instance_double("Faraday::Response", body: { "success" => true }) }

      it do
        expect(client).to receive(:delete).and_call_original

        expect(subject.delete("media_id")).to eq true
      end
    end

    context "failure" do
      let(:response) { instance_double("Faraday::Response", body: { "error" => { "message" => "Error message" } }) }

      it do
        expect(client).to receive(:delete).and_call_original

        expect(subject.delete("media_id")).to eq "Error message"
      end
    end
  end
end
