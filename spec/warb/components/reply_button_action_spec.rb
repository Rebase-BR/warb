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

    context "errors" do
      subject { reply_button_action }

      it do
        subject.buttons_texts = []

        expect { subject.to_h }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              buttons_texts: :at_least_1_item
            }
          )
        end
      end

      it do
        subject.buttons_texts = ["Text"] * 4

        expect { subject.to_h }.to raise_error(Warb::Error) do |error|
          expect(error.errors).to eq(
            {
              button_text: :not_unique,
              buttons_texts: :at_most_3_items
            }
          )
        end
      end
    end
  end
end
