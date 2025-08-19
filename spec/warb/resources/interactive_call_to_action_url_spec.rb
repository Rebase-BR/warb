# frozen_string_literal: true

RSpec.describe Warb::Resources::InteractiveCallToActionUrl do
  let(:header) { build(:text, content: 'Header').build_header }
  let(:action) { build(:cta_action) }
  let(:cta) { build(:cta, header: header, action: action, body: 'Body', footer: 'Footer') }

  describe '#build_header' do
    it do
      expect { cta.build_header }.to raise_error NotImplementedError
    end
  end

  describe '#build_payload' do
    subject { cta.build_payload }

    it do
      expect(subject).to eq(
        {
          type: 'interactive',
          interactive: {
            type: 'cta_url',
            header: {
              type: 'text',
              text: 'Header'
            },
            body: {
              text: 'Body'
            },
            footer: {
              text: 'Footer'
            },
            action: action.to_h
          }
        }
      )
    end
  end

  context 'headers' do
    subject { described_class.new }

    describe '#add_text_header' do
      it do
        expect { subject.add_text_header('Header') }.to change(subject, :header)
          .from(nil).to({ type: 'text', text: 'Header' })
      end
    end

    describe '#add_image_header' do
      it do
        expect { subject.add_image_header(link: 'link_to_image') }.to change(subject, :header)
          .from(nil).to({ type: 'image', image: { link: 'link_to_image', id: nil } })
      end
    end

    describe '#add_video_header' do
      it do
        expect { subject.add_video_header(link: 'link_to_video') }.to change(subject, :header)
          .from(nil).to({ type: 'video', video: { link: 'link_to_video', id: nil } })
      end
    end

    describe '#add_document_header' do
      it do
        expect do
          subject.add_document_header(link: 'link_to_document', filename: 'document.pdf')
        end.to change(subject, :header)
          .from(nil).to({ type: 'document', document: { link: 'link_to_document', id: nil, filename: 'document.pdf' } })
      end
    end
  end

  describe '#build_action' do
    context 'returned value' do
      it do
        action = cta.build_action(button_text: 'Button Text')
        expect(action).to be cta.action
        expect(action).to be_a Warb::Components::CTAAction
        expect(action.button_text).to eq 'Button Text'
      end
    end

    context 'returned block instance' do
      it do
        cta.build_action(button_text: 'Button Text') do |action|
          expect(action).to be cta.action
          expect(action).to be_a Warb::Components::CTAAction
          expect(action.button_text).to eq 'Button Text'
        end
      end
    end
  end
end
