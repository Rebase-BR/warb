# frozen_string_literal: true

RSpec.describe Warb::Resources::InteractiveList do
  let(:header) { build(:text, content: 'Header').build_header }
  let(:action) { build(:interactive_list_action) }
  let(:interactive_list) { build(:interactive_list, header: header, action: action, body: 'Body', footer: 'Footer') }

  describe '#build_header' do
    it do
      expect { interactive_list.build_header }.to raise_error NotImplementedError
    end
  end

  describe '#build_payload' do
    subject { interactive_list.build_payload }

    it do
      expect(subject).to eq(
        {
          type: 'interactive',
          interactive: {
            type: 'list',
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
      it { expect { subject.add_image_header }.to raise_error NotImplementedError }
    end

    describe '#add_video_header' do
      it { expect { subject.add_video_header }.to raise_error NotImplementedError }
    end

    describe '#add_document_header' do
      it { expect { subject.add_document_header }.to raise_error NotImplementedError }
    end
  end

  describe '#build_action' do
    context 'returned value' do
      it do
        action = interactive_list.build_action(button_text: 'Button Text')
        expect(action).to be interactive_list.action
        expect(action).to be_a Warb::Components::ListAction
        expect(action.button_text).to eq 'Button Text'
      end
    end

    context 'returned block instance' do
      it do
        interactive_list.build_action(button_text: 'Button Text') do |action|
          expect(action).to be interactive_list.action
          expect(action).to be_a Warb::Components::ListAction
          expect(action.button_text).to eq 'Button Text'
        end
      end
    end
  end
end
