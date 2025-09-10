# frozen_string_literal: true

RSpec.describe Warb::Components::FlowButton do
  describe '#to_h' do
    context 'when only index is provided (no token, no action_data)' do
      subject { build(:flow_button, index: 0, flow_token: nil, flow_action_data: nil) }

      it 'builds parameters with empty action (no default token locally)' do
        expect(subject.to_h).to match({
                                        type: 'button',
                                        sub_type: 'flow',
                                        index: 0,
                                        parameters: [
                                          {
                                            type: 'action',
                                            action: {}
                                          }
                                        ]
                                      })
      end
    end

    context 'when custom flow_token is provided' do
      subject { build(:flow_button, :with_token, index: 1) }

      it 'includes custom flow_token' do
        expect(subject.to_h).to match({
                                        type: 'button',
                                        sub_type: 'flow',
                                        index: 1,
                                        parameters: [
                                          {
                                            type: 'action',
                                            action: { flow_token: 'TOKEN_123' }
                                          }
                                        ]
                                      })
      end
    end

    context 'when flow_action_data is provided without token' do
      subject { build(:flow_button, index: 0, flow_action_data: { nome: 'Ana' }) }

      it 'includes only flow_action_data under action' do
        expect(subject.to_h).to match({
                                        type: 'button',
                                        sub_type: 'flow',
                                        index: 0,
                                        parameters: [
                                          {
                                            type: 'action',
                                            action: { flow_action_data: { nome: 'Ana' } }
                                          }
                                        ]
                                      })
      end
    end

    context 'when both token and action_data are provided (complete)' do
      subject { build(:flow_button, :complete, index: 2) }

      it 'includes both token and action_data' do
        expect(subject.to_h).to match({
                                        type: 'button',
                                        sub_type: 'flow',
                                        index: 2,
                                        parameters: [
                                          {
                                            type: 'action',
                                            action: {
                                              flow_token: 'TOKEN_ABC',
                                              flow_action_data: { foo: 'bar' }
                                            }
                                          }
                                        ]
                                      })
      end
    end
  end
end
