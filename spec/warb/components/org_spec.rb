# frozen_string_literal: true

RSpec.describe Warb::Components::Org do
  describe '#to_h' do
    subject { org.to_h }

    let(:org) { described_class.new company: 'Company', department: 'Deparment', title: 'Org' }

    context 'built from given params' do
      it do
        expect(subject).to eq(
          {
            title: 'Org',
            company: 'Company',
            department: 'Deparment'
          }
        )
      end
    end

    context 'overwriting some values' do
      before do
        org.department = 'Depart.'
      end

      it do
        expect(subject).to eq(
          {
            title: 'Org',
            company: 'Company',
            department: 'Depart.'
          }
        )
      end
    end
  end
end
