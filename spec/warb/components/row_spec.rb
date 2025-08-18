# frozen_string_literal: true

RSpec.describe Warb::Components::Row do
  let(:row) { build :row }

  describe '#to_h' do
    subject { row.to_h }

    it { is_expected.to eq({ title: row.title, description: row.description }) }
  end
end
