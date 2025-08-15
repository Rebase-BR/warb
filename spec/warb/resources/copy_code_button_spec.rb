# frozen_string_literal: true

RSpec.describe Warb::Components::CopyCodeButton do
  let(:copy_code_button_resource) do
    build :copy_code_button, index: 0, coupon_code: 'SAVE20'
  end

  describe '#to_h' do
    it 'returns the correct payload structure with parameters' do
      expect(copy_code_button_resource.to_h).to eq(
        {
          type: 'button',
          sub_type: 'copy_code',
          index: 0,
          parameters: [
            {
              type: 'coupon_code',
              coupon_code: 'SAVE20'
            }
          ]
        }
      )
    end

    context 'when coupon_code is nil' do
      let(:copy_code_button_resource) do
        build :copy_code_button, index: 0, coupon_code: nil
      end

      it 'returns payload without parameters' do
        expect(copy_code_button_resource.to_h).to eq(
          {
            type: 'button',
            sub_type: 'copy_code',
            index: 0
          }
        )
      end
    end
  end
end
