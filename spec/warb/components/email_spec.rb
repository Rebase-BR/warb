# frozen_string_literal: true

RSpec.describe Warb::Components::Email do
  describe "#to_h" do
    let(:email) { described_class.new email: "email@example.com", type: "WORK" }

    subject { email.to_h }

    context "built from given params" do
      it do
        is_expected.to eq(
          {
            email: "email@example.com",
            type: "WORK"
          }
        )
      end
    end

    context "overwriting some values" do
      before do
        email.email = "personal@example.com"
        email.type = "HOME"
      end

      it do
        is_expected.to eq(
          {
            email: "personal@example.com",
            type: "HOME"
          }
        )
      end
    end
  end
end
