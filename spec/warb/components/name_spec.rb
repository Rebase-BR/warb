# frozen_string_literal: true

RSpec.describe Warb::Components::Name do
  describe '#to_h' do
    subject { name.to_h }

    let(:name) do
      described_class.new formatted_name: 'Formatted Name', first_name: 'first_name', last_name: 'last_name',
                          middle_name: 'middle_name', suffix: 'suffix', prefix: 'Sr'
    end

    context 'built from given params' do
      it do
        expect(subject).to eq(
          {
            formatted_name: 'Formatted Name',
            first_name: 'first_name',
            last_name: 'last_name',
            middle_name: 'middle_name',
            suffix: 'suffix',
            prefix: 'Sr'
          }
        )
      end
    end

    context 'overwriting some values' do
      before do
        name.first_name = 'wife_name'
        name.prefix = 'Sra'
      end

      it do
        expect(subject).to eq(
          {
            formatted_name: 'Formatted Name',
            first_name: 'wife_name',
            last_name: 'last_name',
            middle_name: 'middle_name',
            suffix: 'suffix',
            prefix: 'Sra'
          }
        )
      end
    end
  end
end
