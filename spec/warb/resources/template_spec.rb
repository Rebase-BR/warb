# frozen_string_literal: true

RSpec.describe Warb::Resources::Template do
  subject { described_class.new }

  describe "#build_payload" do
    context "with positional paremters" do
      before do
        allow(subject).to receive_messages(
          name: "template_name",
          language: Warb::Language::ENGLISH_US,
          resources: [
            Warb::Resources::Text.new(content: "First Param"),
            Warb::Resources::Text.new(content: "Second Param"),
            Warb::Resources::Currency.new(amount: 12.34, code: Warb::Resources::Currency::USD, fallback: "$ 12.34"),
            Warb::Resources::DateTime.new("December, 25th")
          ]
        )
      end

      it do
        expect(subject.build_payload).to eq(
          {
            type: "template",
            template: {
              name: "template_name",
              language: {
                code: "en_US"
              },
              components: [
                {
                  type: "body",
                  parameters: [
                    {
                      type: "text",
                      text: "First Param"
                    },
                    {
                      type: "text",
                      text: "Second Param"
                    },
                    {
                      type: "currency",
                      currency: {
                        amount_1000: 12_340,
                        code: "USD",
                        fallback_value: "$ 12.34"
                      }
                    },
                    {
                      type: "date_time",
                      date_time: {
                        fallback_value: "December, 25th"
                      }
                    }
                  ]
                }
              ]
            }
          }
        )
      end
    end

    context "with named parameters" do
      before do
        allow(subject).to receive_messages(
          name: "template_name",
          language: Warb::Language::PORTUGUESE_BR,
          resources: {
            first_param: Warb::Resources::Text.new(content: "First Param"),
            second_param: Warb::Resources::Text.new(content: "Second Param"),
            value: Warb::Resources::Currency.new(amount: 10, code: "BRL"),
            purchase_date: Warb::Resources::DateTime.new("07/09")
          }
        )
      end

      it do
        expect(subject.build_payload).to eq(
          {
            type: "template",
            template: {
              name: "template_name",
              language: {
                code: "pt_BR"
              },
              components: [
                {
                  type: "body",
                  parameters: [
                    {
                      type: "text",
                      text: "First Param",
                      parameter_name: "first_param"
                    },
                    {
                      type: "text",
                      text: "Second Param",
                      parameter_name: "second_param"
                    },
                    {
                      type: "currency",
                      parameter_name: "value",
                      currency: {
                        code: "BRL",
                        fallback_value: "10 (BRL)",
                        amount_1000: 10_000
                      }
                    },
                    {
                      type: "date_time",
                      parameter_name: "purchase_date",
                      date_time: {
                        fallback_value: "07/09"
                      }
                    }
                  ]
                }
              ]
            }
          }
        )
      end
    end
  end
end
