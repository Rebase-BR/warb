# frozen_string_literal: true
require 'byebug'

RSpec.describe Warb::Resources::Flow do

  let(:flow_resource) { build :flow }

  describe '#build_payload' do
    context 'complete structure' do
      let(:flow_resource) { build :flow, :complete_structure }
      subject { flow_resource.build_payload }

      it 'with correct types of data' do
        expect(subject).to include(:type, :interactive)
        expect(subject[:type]).to eq('interactive')

        interactive = subject[:interactive]
        expect(interactive[:type]).to eq('flow')
        expect(interactive[:action]).to be_a(Hash)
        expect(interactive[:action][:name]).to eq('flow')

        header = interactive[:header]
        case header[:type]
          when "text" then expect(header[:text]).to be_a(String)
          when "image" then expect(header[:image]).to include(:id).or include(:link)
          when "video" then expect(header[:video]).to include(:id).or include(:link)
          when "document" then expect(header[:document]).to include(:id).or include(:link)
        end
        expect(interactive[:body][:text]).to be_a(String)
        expect(interactive[:footer][:text]).to be_a(String)
      end
    end

    context 'with optional fields' do
      subject { flow_resource.build_payload }

      it 'omits header/footer when blank' do
        expect(subject[:interactive]).not_to have_key(:header)
        expect(subject[:interactive]).not_to have_key(:footer)
      end
    end

    context 'with necessary values' do
      subject { flow_resource.build_payload }

      it 'and default parameters' do
        params = subject[:interactive][:action][:parameters]
        expect(params[:flow_message_version]).to eq('3')
        expect(params[:flow_id]).to be_a(String)
        expect(params[:flow_action]).to eq('navigate')
        expect(params[:mode]).to eq('published')
        expect(params[:flow_action_payload][:screen]).to be_a(String)
      end

      let(:flow_resource) { build :flow, :with_initial_data }

      it 'and initial data' do
        payload = subject[:interactive][:action][:parameters][:flow_action_payload]

        expect(payload[:data][:prefill][:name]).to be_a(String)
        expect(payload[:data][:prefill][:email]).to be_a(String)
      end
    end

    context 'dynamic flow' do
      let(:flow_resource) { build :flow, :dynamic }
      subject { flow_resource.build_payload }

      it 'does not include flow_action_payload with screen or data' do
        payload = subject[:interactive][:action][:parameters]
        expect(payload[:flow_action]).to eq('data_exchange')
        expect(payload).not_to have_key(:flow_action_payload)
      end
    end

    context 'validation' do
      it 'raises when flow_id is missing' do
        resource = build(:flow, flow_id: nil)
        expect { resource.build_payload }.to raise_error(ArgumentError, /flow_id is required/)
      end

      it 'raises when action=navigate and screen is missing' do
        resource = build(:flow, screen: nil)
        expect { resource.build_payload }.to raise_error(ArgumentError, /screen is required/)
      end

      it 'does not raise when action=data_exchange without screen' do
        resource = build(:flow, body: nil)
        expect { resource.build_payload }.to raise_error(ArgumentError, /body is required/)
      end
    end

    context 'attribute precedence (instance ivars over params hash over defaults)' do
      subject { flow_resource.build_payload }

      it 'prefers explicit ivars over constructor params' do
        flow_resource.flow_id = 'FROM_IVAR'
        flow_resource.screen  = 'FROM_IVAR'

        params = subject[:interactive][:action][:parameters]
        expect(params[:flow_id]).to eq('FROM_IVAR')
        expect(params[:flow_action_payload][:screen]).to eq('FROM_IVAR')
      end
    end
  end
end
