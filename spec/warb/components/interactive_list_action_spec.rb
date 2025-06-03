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

    subject { list_action.to_h }

    context "button text" do
      it { expect(subject[:button]).to eq list_action.button_text }
    end

    context "sections count" do
      it { expect(subject[:sections].count).to eq list_action.sections.count }
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
  end
end
