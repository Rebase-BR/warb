# frozen_string_literal: true

RSpec.describe Warb::TemplateDispatcher do
  subject { described_class.new Warb::Resources::Template, Warb.client }

  context "parent" do
    it do
      expect(described_class.superclass).to be Warb::Dispatcher
    end
  end

  describe "#create" do
    context "called endpoint" do
      it do
        expect_any_instance_of(Warb::Resources::Template).to receive(:creation_payload).and_call_original
        expect_any_instance_of(Warb::Client).to receive(:post).with(
          "message_templates",
          {
            name: "name",
            language: "pt_BR",
            category: "MARKETING",
            components: []
          }, endpoint_prefix: :business_id
        )

        subject.create(name: "name", language: Warb::Language::PORTUGUESE_BR, category: Warb::Category::MARKETING)
      end
    end
  end
end
