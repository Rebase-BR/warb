# frozen_string_literal: true

RSpec.describe Warb::MediaDispatcher do
  class MediaResource < Warb::Resources::Resource; end

  subject { service }

  let(:client) { Warb.client }
  let(:service) { described_class.new(MediaResource, client) }

  describe '#upload' do
    subject { service.upload(file_path:, file_type:) }

    let(:file_path) { 'spec/warb/media_dispatcher_spec.rb' }
    let(:file_type) { 'text/plain' }
    let(:file) { double('Faraday::UploadIO') }

    let(:data) do
      { file:, messaging_product: 'whatsapp' }
    end

    let(:mock_response) { double('response', body: { 'id' => 'media_123456' }) }

    before do
      allow(Faraday::UploadIO).to receive(:new).and_return(file)
    end

    it do
      expect(client).to receive(:post)
        .with('media', data, multipart: true)
        .and_return(mock_response)

      expect(subject).to eq 'media_123456'
    end
  end

  describe '#download' do
    let(:response) { instance_double(Net::HTTPOK, body: 'file binary data') }

    before do
      http = instance_double(Net::HTTP, request: response)
      allow(Net::HTTP).to receive(:start).and_yield(http)
    end

    after { FileUtils.rm_f('downloaded_file') }

    it do
      expect(File).not_to exist('downloaded_file')

      subject.download file_path: 'downloaded_file', media_url: 'http://example.com/file.bin'

      expect(File).to exist('downloaded_file')
      expect(File.read('downloaded_file')).to eq 'file binary data'
    end
  end

  describe '#retrieve' do
    before do
      faraday_ok = instance_double(Faraday::Response,
                                   status: 200,
                                   body: {},
                                   headers: {},
                                   success?: true)

      expect_any_instance_of(Faraday::Connection)
        .to receive(:send).with('get', 'media_id', {}, {})
        .and_return(faraday_ok)
    end

    it do
      expect(client).to receive(:get).and_call_original
      subject.retrieve 'media_id'
    end
  end

  describe '#delete' do
    context 'success' do
      it do
        faraday_ok = instance_double(Faraday::Response,
                                     status: 200,
                                     body: { 'success' => true },
                                     headers: {},
                                     success?: true)

        expect_any_instance_of(Faraday::Connection)
          .to receive(:send).with('delete', 'media_id', {}, {})
          .and_return(faraday_ok)

        expect(client).to receive(:delete).and_call_original

        expect(subject.delete('media_id')).to be true
      end
    end

    context 'failure' do
      it do
        faraday_ok_with_error = instance_double(Faraday::Response,
                                                status: 200,
                                                body: { 'error' => { 'message' => 'Error message' } },
                                                headers: {},
                                                success?: true)

        expect_any_instance_of(Faraday::Connection)
          .to receive(:send).with('delete', 'media_id', {}, {})
          .and_return(faraday_ok_with_error)

        expect(client).to receive(:delete).and_call_original

        expect(subject.delete('media_id')).to eq 'Error message'
      end
    end
  end
end
