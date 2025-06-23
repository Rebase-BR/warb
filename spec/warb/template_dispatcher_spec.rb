# frozen_string_literal: true

RSpec.describe Warb::TemplateDispatcher do
  subject { described_class.new Object, Warb.client }

  context "parent" do
    it do
      expect(described_class.superclass).to be Warb::Dispatcher
    end
  end

  describe "#list" do
    it do
      expect_any_instance_of(Warb::Client).to receive(:get).with("message_templates", endpoint_prefix: :business_id)

      subject.list
    end
  end
end
