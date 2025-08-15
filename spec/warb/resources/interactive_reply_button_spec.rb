# frozen_string_literal: true

RSpec.describe Warb::Resources::InteractiveReplyButton do
  let(:header) { build(:text, content: 'Header').build_header }
  let(:action) { build(:reply_button_action) }
  let(:reply_button) { build(:reply_button, header: header, action: action, body: 'Body', footer: 'Footer') }

  describe '#build_header' do
    it do
      expect { reply_button.build_header }.to raise_error NotImplementedError
    end
  end

  describe '#build_payload' do
    subject { reply_button.build_payload }

    it do
      expect(subject).to eq(
        {
          type: 'interactive',
          interactive: {
            type: 'button',
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

    describe '#set_text_header' do
      it do
        expect { subject.set_text_header('Header') }.to change(subject, :header)
          .from(nil).to({ type: 'text', text: 'Header' })
      end
    end

    describe '#set_image_header' do
      it do
        expect { subject.set_image_header(link: 'link_to_image') }.to change(subject, :header)
          .from(nil).to({ type: 'image', image: { link: 'link_to_image', id: nil } })
      end

      it do
        expect { subject.set_image_header(media_id: 'image_id') }.to change(subject, :header)
          .from(nil).to({ type: 'image', image: { link: nil, id: 'image_id' } })
      end
    end

    describe '#set_video_header' do
      it do
        expect { subject.set_video_header(link: 'link_to_video') }.to change(subject, :header)
          .from(nil).to({ type: 'video', video: { link: 'link_to_video', id: nil } })
      end

      it do
        expect { subject.set_video_header(media_id: 'video_id') }.to change(subject, :header)
          .from(nil).to({ type: 'video', video: { link: nil, id: 'video_id' } })
      end
    end

    describe '#set_document_header' do
      it do
        expect { subject.set_document_header(link: 'link_to_document') }.to change(subject, :header)
          .from(nil).to({ type: 'document', document: { link: 'link_to_document', id: nil, filename: nil } })
      end

      it do
        expect { subject.set_document_header(media_id: 'document_id', filename: 'document.pdf') }.to change(
          subject, :header
        ).from(nil).to({ type: 'document', document: { link: nil, id: 'document_id', filename: 'document.pdf' } })
      end
    end
  end

  describe '#build_action' do
    context 'returned value' do
      it do
        action = reply_button.build_action(buttons_texts: ['Button 1'])
        expect(action).to be reply_button.action
        expect(action).to be_a Warb::Components::ReplyButtonAction
        expect(action.buttons_texts).to eq ['Button 1']
      end
    end

    context 'returned block instance' do
      it do
        reply_button.build_action(buttons_texts: ['Button 1']) do |action|
          expect(action).to be reply_button.action
          expect(action).to be_a Warb::Components::ReplyButtonAction
          expect(action.buttons_texts).to eq ['Button 1']
        end
      end
    end
  end
end
