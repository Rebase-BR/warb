# frozen_string_literal: true

RSpec.describe Warb::TemplateDispatcher do
  subject { described_class.new Object, Warb.client }

  context 'parent' do
    it do
      expect(described_class.superclass).to be Warb::Dispatcher
    end
  end

  describe '#list' do
    let(:response) { instance_double(Faraday::Response, body: nil) }

    context 'basic' do
      it do
        expect_any_instance_of(Warb::Client).to receive(:get).with('message_templates', endpoint_prefix: :business_id,
                                                                                        data: {}).and_return(response)

        subject.list
      end
    end

    context 'filtering' do
      it do
        expect_any_instance_of(Warb::Client).to receive(:get).with('message_templates', endpoint_prefix: :business_id,
                                                                                        data: {
                                                                                          limit: 5,
                                                                                          fields: 'status,category'
                                                                                        }).and_return(response)

        subject.list(limit: 5, fields: %i[status category], invalid_field: 'whatever')
      end
    end
  end
end
