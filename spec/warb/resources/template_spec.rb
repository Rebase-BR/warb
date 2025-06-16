# frozen_string_literal: true

RSpec.describe Warb::Resources::Template do
  subject { described_class.new }

  describe "#build_payload" do
    context "with positional paremters" do
      before do
        allow(subject).to receive_messages(
          name: "template_name",
          language: Warb::Language::ENGLISH_US,
          parameters: ["First Param", "Second Param"]
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
          parameters: {
            first_param: "First Param",
            second_param: "Second Param"
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
