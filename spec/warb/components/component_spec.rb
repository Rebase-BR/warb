# frozen_string_literal: true

RSpec.describe Warb::Components::Component do
  describe '#to_h' do
    subject { described_class.new {} }

    it 'defines the default behavior' do
      expect { subject.to_h }.to raise_error NotImplementedError
    end
  end
end
