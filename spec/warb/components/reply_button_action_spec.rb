# frozen_string_literal: true

RSpec.describe Warb::Components::ReplyButtonAction do
  let(:reply_button_action) { build :reply_button_action, buttons_texts: ["Botão #1", "Botão #2"] }

  describe "#to_h" do
    context "buttons" do
      subject { reply_button_action.to_h }

      it { is_expected.to include :buttons }
      it { expect(subject[:buttons].count).to eq 2 }
      it { expect(subject[:buttons][0]).to eq({ type: "reply", reply: { id: "botao#1_0", title: "Botão #1" } }) }
      it { expect(subject[:buttons][1]).to eq({ type: "reply", reply: { id: "botao#2_1", title: "Botão #2" } }) }
    end
  end

  describe "#add_button_text" do
    subject { reply_button_action }

    it do
      expect { subject.add_button_text("Botão #3") }.to change(subject.buttons_texts, :count).by(1)
      expect(subject.buttons_texts.last).to eq "Botão #3"
    end
  end
end
