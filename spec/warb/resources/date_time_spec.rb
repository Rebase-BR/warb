# frozen_string_literal: true

RSpec.describe Warb::Resources::DateTime do
  subject { described_class.new 'Jan, 1st, 2020' }

  describe '#build_template_named_parameter' do
    it do
      expect(subject.build_template_named_parameter('purchase_date')).to eq(
        {
          type: 'date_time',
          date_time: {
            fallback_value: 'Jan, 1st, 2020'
          },
          parameter_name: 'purchase_date'
        }
      )
    end
  end

  describe '#build_template_positional_parameter' do
    it do
      expect(subject.build_template_positional_parameter).to eq(
        {
          type: 'date_time',
          date_time: {
            fallback_value: 'Jan, 1st, 2020'
          }
        }
      )
    end
  end
end
