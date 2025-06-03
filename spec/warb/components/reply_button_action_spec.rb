# frozen_string_literal: true

RSpec.describe Warb::Components::ReplyButtonAction do
  describe "#to_h" do
    let(:reply_button_action) { build :reply_button_action, buttons_texts: ["Botão #1", "Botão #2"] }

    context "buttons" do
      subject { reply_button_action.to_h }

      it { is_expected.to include :buttons }
      it { expect(subject[:buttons].count).to eq 2 }
      it { expect(subject[:buttons][0]).to eq({ type: "reply", reply: { id: "botao#1_0", title: "Botão #1" } }) }
      it { expect(subject[:buttons][1]).to eq({ type: "reply", reply: { id: "botao#2_1", title: "Botão #2" } }) }
    end
  end
end
