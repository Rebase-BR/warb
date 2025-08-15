# frozen_string_literal: true

RSpec.describe Warb::Resources::Currency do
  subject do
    described_class.new amount: 12.34, code: Warb::Resources::Currency::USD,
                        fallback: '$12.34'
  end

  describe '#build_template_named_parameter' do
    context 'with fallback value defined' do
      it do
        expect(subject.build_template_named_parameter('amount')).to eq(
          {
            type: 'currency',
            currency: {
              amount_1000: 12_340,
              code: 'USD',
              fallback_value: '$12.34'
            },
            parameter_name: 'amount'
          }
        )
      end
    end
  end

  describe '#build_template_positional_parameter' do
    context 'without fallback value defined' do
      before do
        subject.fallback = nil
        subject.code = Warb::Resources::Currency::BRL
      end

      it do
        expect(subject.build_template_positional_parameter).to eq(
          {
            type: 'currency',
            currency: {
              amount_1000: 12_340,
              code: 'BRL',
              fallback_value: '12.34 (BRL)'
            }
          }
        )
      end
    end
  end
end
