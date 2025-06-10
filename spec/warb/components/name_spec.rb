# frozen_string_literal: true

RSpec.describe Warb::Components::Name do
  describe "#to_h" do
    let(:name) do
      described_class.new formatted_name: "Formatted Name", first_name: "first_name", last_name: "last_name",
                          middle_name: "middle_name", suffix: "suffix", prefix: "Sr"
    end

    subject { name.to_h }

    context "built from given params" do
      it do
        is_expected.to eq(
          {
            formatted_name: "Formatted Name",
            first_name: "first_name",
            last_name: "last_name",
            middle_name: "middle_name",
            suffix: "suffix",
            prefix: "Sr"
          }
        )
      end

      context "errors" do
        it do
          allow(name).to receive_messages(
            formatted_name: nil, first_name: nil, last_name: nil,
            middle_name: nil, suffix: nil, prefix: nil
          )

          expect { name.to_h }.to raise_error(Warb::Error) do |error|
            expect(error.errors).to eq(
              {
                formatted_name: :required
              }
            )
          end
        end

        it do
          allow(name).to receive_messages(
            first_name: nil, last_name: nil, middle_name: nil,
            suffix: nil, prefix: nil
          )

          expect { name.to_h }.to raise_error(Warb::Error) do |error|
            expect(error.errors).to eq(
              {
                formatted_name: :required_at_least_1_from_prefix__first_name__middle_name__last_name__suffix
              }
            )
          end
        end
      end
    end

    context "overwriting some values" do
      before do
        name.first_name = "wife_name"
        name.prefix = "Sra"
      end

      it do
        is_expected.to eq(
          {
            formatted_name: "Formatted Name",
            first_name: "wife_name",
            last_name: "last_name",
            middle_name: "middle_name",
            suffix: "suffix",
            prefix: "Sra"
          }
        )
      end
    end
  end
end
