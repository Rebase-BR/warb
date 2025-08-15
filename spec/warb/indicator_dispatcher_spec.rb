# frozen_string_literal: true

RSpec.describe Warb::IndicatorDispatcher do
  subject { described_class.new client }

  let(:client) { Warb.client }

  describe '#send_typing_indicator' do
    let(:data) do
      {
        messaging_product: 'whatsapp',
        message_id: 'message_id',
        status: 'read',
        typing_indicator: {
          type: 'text'
        }
      }
    end

    it do
      expect(client).to receive(:post).with('messages', data)

      subject.send_typing_indicator('message_id')
    end
  end

  describe '#mark_as_read' do
    let(:data) { { messaging_product: 'whatsapp', message_id: 'message_id', status: 'read' } }

    it do
      expect(client).to receive(:post).with('messages', data)

      subject.mark_as_read('message_id')
    end
  end
end
