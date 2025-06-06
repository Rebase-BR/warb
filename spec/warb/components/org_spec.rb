# frozen_string_literal: true

RSpec.describe Warb::Components::Org do
  describe "#to_h" do
    let(:org) { described_class.new company: "Company", department: "Deparment", title: "Org" }

    subject { org.to_h }

    context "built from given params" do
      it do
        is_expected.to eq(
          {
            title: "Org",
            company: "Company",
            department: "Deparment"
          }
        )
      end
    end

    context "overwriting some values" do
      before do
        org.department = "Depart."
      end

      it do
        is_expected.to eq(
          {
            title: "Org",
            company: "Company",
            department: "Depart."
          }
        )
      end
    end
  end
end
