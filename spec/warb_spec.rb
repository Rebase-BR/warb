# frozen_string_literal: true

RSpec.describe Warb do
  after do
    described_class.instance_variable_set(:@client, nil)
    described_class.instance_variable_set(:@configuration, nil)
  end

  it 'has a version number' do
    expect(Warb::VERSION).not_to be_nil
  end

  it { expect(described_class.singleton_class.included_modules).to include Warb::DispatcherConcern }

  describe '.new' do
    it do
      expect(Warb::Client).to receive(:new).with({ access_token: 'token' })

      described_class.new(access_token: 'token')
    end
  end

  describe '.client' do
    context 'without previous .client call' do
      context 'without previous configuration' do
        let(:configuration) { Warb::Configuration.new }

        before { allow(Warb::Configuration).to receive(:new).and_return(configuration) }

        it do
          expect(Warb::Configuration).to receive(:new).and_return(configuration)
          expect(Warb::Client).to receive(:new).with(configuration)

          described_class.client
        end
      end

      context 'with previous configuration' do
        it do
          configuration = described_class.configuration

          expect(Warb::Configuration).not_to receive(:new)
          expect(Warb::Client).to receive(:new).with(configuration)

          described_class.client
        end
      end
    end

    context 'with previous .client call' do
      before { described_class.client }

      it do
        expect(Warb::Client).not_to receive(:new)

        described_class.client
      end
    end
  end

  describe '.setup' do
    context 'returned instance' do
      it do
        client = described_class.setup do |config|
          expect(config).to be_a Warb::Configuration
        end

        expect(client).to be_a Warb::Client
      end
    end

    context 'client instatiation with previous .setup call' do
      before do
        described_class.setup do |_setup|
          # empty
        end
      end

      it do
        expect(Warb::Client).not_to receive(:new)

        described_class.setup do |_setup|
          # empty
        end
      end
    end

    context 'client instatiation without previous .setup call' do
      it do
        expect(Warb::Client).to receive(:new)

        described_class.setup do |_setup|
          # empty
        end
      end
    end
  end
end
