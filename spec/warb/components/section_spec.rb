# frozen_string_literal: true

RSpec.describe Warb::Components::Section do
  describe "#add_row" do
    let(:section) { build :section }

    context "rows count" do
      it do
        expect { section.add_row }.to change(section.rows, :count).by(1)
      end
    end

    context "added object class" do
      subject { section.add_row }

      it { is_expected.to be_a Warb::Components::Row }
    end

    context "initialized with" do
      subject { section.add_row title: "Title", description: "Description" }

      it { expect(subject.title).to eq "Title" }
      it { expect(subject.description).to eq "Description" }
    end
  end

  describe "#to_h" do
    let(:row) { build :row, title: "Título" }
    let(:section) { build :section, rows: [row] }

    subject { section.to_h }

    context "title" do
      it { expect(subject[:title]).to eq section.title }
    end

    context "rows" do
      context "count" do
        it { expect(subject[:rows].count).to eq section.rows.count }
      end

      context "first row" do
        it do
          expect(subject[:rows].first).to eq(
            {
              id: "titulo_0",
              title: row.title,
              description: row.description
            }
          )
        end
      end
    end

    context "serializations" do
      before do
        allow(section).to receive(:to_h).and_call_original
        allow(section.rows).to receive(:map).and_call_original
        allow(row).to receive(:to_h).and_call_original
      end

      it do
        expect(section).to receive(:to_h)
        expect(section.rows).to receive(:map)
        expect(row).to receive(:to_h)

        section.to_h
      end
    end
  end
end
