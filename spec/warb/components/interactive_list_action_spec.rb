# frozen_string_literal: true

RSpec.describe Warb::Components::ListAction do
  describe "#add_section" do
    let(:list_action) { build :interactive_list_action }

    context "sections count" do
      it do
        expect { list_action.add_section }.to change(list_action.sections, :count).by(1)
      end
    end

    context "added object class" do
      subject { list_action.add_section }

      it { is_expected.to be_a Warb::Components::Section }
    end

    context "initialized with" do
      subject { list_action.add_section title: "Open Options" }

      it { expect(subject.title).to eq "Open Options" }
      it { expect(subject.rows).to eq [] }
    end
  end

  describe "#to_h" do
    let(:section) { build :section, title: "Título" }
    let(:list_action) { build :interactive_list_action, sections: [section] }

    subject { list_action }

    context "button text" do
      it { expect(subject.to_h[:button]).to eq list_action.button_text }
    end

    context "sections count" do
      it { expect(subject.to_h[:sections].count).to eq list_action.sections.count }
    end

    context "serializations" do
      before do
        allow(section).to receive(:to_h).and_call_original
        allow(list_action).to receive(:sections).and_call_original
        allow(list_action).to receive(:to_h).and_call_original
        allow(list_action.sections).to receive(:map).and_call_original
      end

      it do
        expect(list_action).to receive(:to_h)
        expect(list_action.sections).to receive(:map)
        expect(section).to receive(:to_h)

        list_action.to_h
      end
    end

    context "errors" do
      it do
        subject.button_text = ""
        subject.sections = []

        expect { subject.to_h }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              button_text: :required,
              sections: :at_least_1_item
            }
          )
        end
      end

      it do
        subject.button_text = "#" * 21
        subject.sections = build_list :section, 11

        expect { subject.to_h }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              button_text: :no_longer_than_20_characters,
              sections: :at_most_10_items
            }
          )
        end
      end

      it do
        subject.sections = build_list(:section, 2, title: nil)

        expect { subject.to_h }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to include(
            section_title: :required_if_multiple_sections
          )
        end
      end
    end
  end
end
