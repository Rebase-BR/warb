# frozen_string_literal: true

RSpec.describe Warb::Resources::Flow do
  let(:flow_resource) { build :flow }

  describe '#build_payload' do
    context 'complete structure' do
      subject { flow_resource.build_payload }

      let(:flow_resource) { build :flow, :complete_structure }

      it 'with correct types of data' do
        expect(subject).to include(:type, :interactive)
        expect(subject[:type]).to eq('interactive')

        interactive = subject[:interactive]
        expect(interactive[:type]).to eq('flow')
        expect(interactive[:action]).to be_a(Hash)
        expect(interactive[:action][:name]).to eq('flow')

        header = interactive[:header]
        case header[:type]
        when 'text' then expect(header[:text]).to be_a(String)
        when 'image' then expect(header[:image]).to include(:id).or include(:link)
        when 'video' then expect(header[:video]).to include(:id).or include(:link)
        when 'document' then expect(header[:document]).to include(:id).or include(:link)
        end
        expect(interactive[:body][:text]).to be_a(String)
        expect(interactive[:footer][:text]).to be_a(String)
        expect(interactive[:action][:parameters][:flow_cta]).to be_a(String)
        expect(interactive[:action][:parameters][:flow_token]).to be_a(String)
      end
    end

    context 'when optional fields are blank' do
      subject { flow_resource.build_payload }

      it 'omits the fields' do
        expect(subject[:interactive]).not_to have_key(:header)
        expect(subject[:interactive]).not_to have_key(:footer)
        expect(subject[:interactive][:action][:parameters]).not_to have_key(:footer)
        expect(subject[:interactive][:action][:parameters]).not_to have_key(:footer)
      end
    end

    context 'with necessary values' do
      subject { flow_resource.build_payload }

      let(:flow_resource) { build :flow, :with_initial_data }

      it 'and default parameters' do
        params = subject[:interactive][:action][:parameters]
        expect(params[:flow_message_version]).to eq('3')
        expect(params[:flow_id]).to be_a(String)
        expect(params[:flow_action]).to eq('navigate')
        expect(params[:mode]).to eq('published')
        expect(params[:flow_action_payload][:screen]).to be_a(String)
      end

      it 'and initial data' do
        payload = subject[:interactive][:action][:parameters][:flow_action_payload]

        expect(payload[:data][:prefill][:name]).to be_a(String)
        expect(payload[:data][:prefill][:email]).to be_a(String)
      end
    end

    context 'boolean flags' do
      subject { build(:flow, draft: true, data_exchange: true).build_payload }

      it 'sets mode to draft and action to data_exchange' do
        params = subject[:interactive][:action][:parameters]
        expect(params[:mode]).to eq('draft')
        expect(params[:flow_action]).to eq('data_exchange')
        expect(params).not_to have_key(:flow_action_payload)
      end
    end

    context 'explicit overrides flags' do
      subject do
        build(:flow, data_exchange: true, screen: 'FIRST', flow_action: 'navigate',
                     draft: true, mode: 'published').build_payload
      end

      it 'uses the explicit flow_action and keeps payload with screen' do
        params = subject[:interactive][:action][:parameters]
        expect(params[:flow_action]).to eq('navigate')
        expect(params[:flow_action_payload]).to include(:screen)
        expect(params[:mode]).to eq('published')
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

  describe 'headers via helpers (factory)' do
    context 'text header' do
      it 'embeds text header' do
        flow = build(:flow)
        flow.add_text_header(text: 'Hello!')
        header = flow.build_payload[:interactive][:header]

        expect(header[:type]).to eq('text')
        expect(header[:text]).to eq('Hello!')
      end
    end

    context 'image header' do
      it 'with id' do
        flow = build(:flow)
        flow.add_image_header(media_id: 'IMG123')

        header = flow.build_payload[:interactive][:header]
        expect(header[:type]).to eq('image')
        expect(header[:image][:id]).to eq('IMG123')
        expect(header[:image][:link]).to be_nil
      end

      it 'with link' do
        flow = build(:flow)
        link = 'https://example.com/img.jpg'
        flow.add_image_header(link:)

        header = flow.build_payload[:interactive][:header]
        expect(header[:type]).to eq('image')
        expect(header[:image][:link]).to eq(link)
        expect(header[:image][:id]).to be_nil
      end
    end

    context 'video header' do
      it 'with id' do
        flow = build(:flow)
        flow.add_video_header(media_id: 'VID123')

        header = flow.build_payload[:interactive][:header]
        expect(header[:type]).to eq('video')
        expect(header[:video][:id]).to eq('VID123')
        expect(header[:video][:link]).to be_nil
      end

      it 'with link' do
        flow = build(:flow)
        link = 'https://example.com/vid.mp4'
        flow.add_video_header(link:)

        header = flow.build_payload[:interactive][:header]
        expect(header[:type]).to eq('video')
        expect(header[:video][:link]).to eq(link)
        expect(header[:video][:id]).to be_nil
      end
    end

    context 'document header' do
      it 'with id' do
        flow = build(:flow)
        flow.add_document_header(media_id: 'DOC999')

        header = flow.build_payload[:interactive][:header]
        expect(header[:type]).to eq('document')
        expect(header[:document][:id]).to eq('DOC999')
        expect(header[:document][:link]).to be_nil
      end

      it 'with link (requires filename)' do
        flow = build(:flow)
        link = 'https://example.com/contract.pdf'
        flow.add_document_header(link:, filename: 'contract.pdf')

        header = flow.build_payload[:interactive][:header]
        expect(header[:type]).to eq('document')
        expect(header[:document][:link]).to eq(link)
        expect(header[:document][:filename]).to eq('contract.pdf')
        expect(header[:document][:id]).to be_nil
      end
    end

    context 'factory :with_header (random type)' do
      it 'includes a valid header in payload regardless of sampled type' do
        flow = build(:flow, :with_header)
        header = flow.build_payload[:interactive][:header]

        expect(header).to be_a(Hash)
        expect(%w[text image video document]).to include(header[:type])

        case header[:type]
        when 'text'
          expect(header[:text]).to be_a(String)
        when 'image'
          expect(header[:image][:id]).to be_a(String).or be_nil
          expect(header[:image][:link]).to be_a(String).or be_nil
          expect([header[:image][:id], header[:image][:link]].compact).not_to be_empty
        when 'video'
          expect(header[:video][:id]).to be_a(String).or be_nil
          expect(header[:video][:link]).to be_a(String).or be_nil
          expect([header[:video][:id], header[:video][:link]].compact).not_to be_empty
        when 'document'
          expect(header[:document][:id]).to be_a(String).or be_nil
          expect(header[:document][:link]).to be_a(String).or be_nil
          expect([header[:document][:id], header[:document][:link]].compact).not_to be_empty
        end
      end
    end
  end
end
