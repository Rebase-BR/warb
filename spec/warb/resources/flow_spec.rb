# frozen_string_literal: true

RSpec.describe Warb::Resources::Contact do
  describe '#build_payload' do
    subject { build(:flow).build_payload }

    it 'validate content' do
      expect(subject).to have_key(:type)
      expect(subject).to have_key(:interactive)
    end
  end
end
