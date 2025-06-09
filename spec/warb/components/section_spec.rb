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

    subject { section }

    context "title" do
      it { expect(subject.to_h[:title]).to eq section.title }
    end

    context "rows" do
      context "count" do
        it { expect(subject.to_h[:rows].count).to eq section.rows.count }
      end

      context "first row" do
        it do
          expect(subject.to_h[:rows].first).to eq(
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

    context "errors" do
      it do
        section.title = nil
        section.rows = []

        expect { subject.to_h }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              rows: :at_least_1_item
            }
          )
        end
      end

      it do
        section.title = "#" * 25
        section.rows = build_list(:row, 11, title: "Title")

        expect { subject.to_h }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              title: :no_longer_than_24_characters,
              rows: :at_most_10_items,
              row_title: :not_unique
            }
          )
        end
      end
    end
  end
end
