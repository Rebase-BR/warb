# frozen_string_literal: true

RSpec.describe Warb::Resources::Template do
  subject { described_class.new }

  describe "#add_currency_parameter" do
    context "positional" do
      it do
        expect do
          subject.add_currency_parameter
        end.to change(subject, :resources).from(NilClass).to(Array)

        expect(subject.resources.last).to be_a Warb::Resources::Currency
      end

      it do
        subject.add_currency_parameter(code: "USD") do |currency|
          expect(currency.code).to eq "USD"
          expect(currency).to eq subject.resources.last
          expect(currency).to be_a Warb::Resources::Currency
        end

        expect { subject.add_currency_parameter("useless_param_name") }.to change(subject.resources, :count).by(1)
      end
    end

    context "named" do
      it do
        expect do
          subject.add_currency_parameter(:purchase_value)
        end.to change(subject, :resources).from(nil).to(Hash)

        expect(subject.resources[:purchase_value]).to be_a Warb::Resources::Currency

        expect { subject.add_currency_parameter }.to change(subject.resources, :count).by(1)
      end
    end
  end

  describe "#add_date_time_paramater" do
    context "positional" do
      it do
        expect do
          subject.add_date_time_parameter
        end.to change(subject, :resources).from(NilClass).to(Array)

        expect(subject.resources.last).to be_a Warb::Resources::DateTime
      end

      it do
        subject.add_date_time_parameter(date_time: "Jan, 1st") do |purchase_date|
          expect(purchase_date.date_time).to eq "Jan, 1st"
          expect(purchase_date).to eq subject.resources.last
          expect(purchase_date).to be_a Warb::Resources::DateTime
        end

        expect { subject.add_date_time_parameter("useless_param_name") }.to change(subject.resources, :count).by(1)
      end
    end

    context "named" do
      it do
        expect do
          subject.add_date_time_parameter(:purchase_date)
        end.to change(subject, :resources).from(nil).to(Hash)

        expect(subject.resources[:purchase_date]).to be_a Warb::Resources::DateTime

        expect { subject.add_date_time_parameter }.to change(subject.resources, :count).by(1)
      end
    end
  end

  describe "#add_text_paramater" do
    context "positional" do
      it do
        expect do
          subject.add_text_parameter
        end.to change(subject, :resources).from(NilClass).to(Array)

        expect(subject.resources.last).to be_a Warb::Resources::Text
      end

      it do
        subject.add_text_parameter do |text|
          expect(text).to eq subject.resources.last
          expect(text).to be_a Warb::Resources::Text
        end

        expect { subject.add_text_parameter("useless_param_name") }.to change(subject.resources, :count).by(1)
      end
    end

    context "named" do
      it do
        expect do
          subject.add_text_parameter(:text)
        end.to change(subject, :resources).from(nil).to(Hash)

        expect(subject.resources[:text]).to be_a Warb::Resources::Text

        expect { subject.add_text_parameter }.to change(subject.resources, :count).by(1)
      end
    end
  end

  describe "#set_text_header" do
    it do
      expect do
        subject.set_text_header(content: "John", parameter_name: "part_of_the_day")
      end.to change(subject, :header).from(NilClass).to(Warb::Resources::Text)
    end
  end

  describe "#set_image_header" do
    context "with id, using block" do
      it do
        expect do
          subject.set_image_header(media_id: "media_id") do |image|
            expect(image).to be_a Warb::Resources::Image
            expect(image).to eq subject.header
          end
        end.to change(subject, :header).from(NilClass).to(Warb::Resources::Image)
      end
    end

    context "with link, without using block" do
      it do
        expect do
          image = subject.set_image_header(link: "media_link")

          expect(image).to be_a Warb::Resources::Image
          expect(image).to eq subject.header
        end.to change(subject, :header).from(NilClass).to(Warb::Resources::Image)
      end
    end
  end

  describe "#set_document_header" do
    context "with id, using block" do
      it do
        expect do
          subject.set_document_header(media_id: "media_id") do |document|
            expect(document).to be_a Warb::Resources::Document
            expect(document).to eq subject.header
          end
        end.to change(subject, :header).from(NilClass).to(Warb::Resources::Document)
      end
    end

    context "with link, without using block" do
      it do
        expect do
          document = subject.set_document_header(link: "media_link")

          expect(document).to be_a Warb::Resources::Document
          expect(document).to eq subject.header
        end.to change(subject, :header).from(NilClass).to(Warb::Resources::Document)
      end
    end
  end

  describe "#set_video_header" do
    context "with id, using block" do
      it do
        expect do
          subject.set_video_header(media_id: "media_id") do |video|
            expect(video).to be_a Warb::Resources::Video
            expect(video).to eq subject.header
          end
        end.to change(subject, :header).from(NilClass).to(Warb::Resources::Video)
      end
    end

    context "with link, without using block" do
      it do
        expect do
          video = subject.set_video_header(link: "media_link")

          expect(video).to be_a Warb::Resources::Video
          expect(video).to eq subject.header
        end.to change(subject, :header).from(NilClass).to(Warb::Resources::Video)
      end
    end
  end

  describe "#add_quick_reply_button" do
    context "with block" do
      it "sets custom index when provided" do
        subject.add_quick_reply_button { |button| button.index = 1 }

        buttons = subject.buttons
        expect(buttons.count).to eq 1
        expect(buttons.last).to match({ type: "button", index: 1, sub_type: "quick_reply" })
      end

      it "uses default position when index not provided" do
        subject.add_quick_reply_button { |button| }

        buttons = subject.buttons
        expect(buttons.count).to eq 1
        expect(buttons.last).to match({ type: "button", index: 0, sub_type: "quick_reply" })
      end
    end

    context "without using block" do
      it "sets custom index when provided" do
        subject.add_quick_reply_button(index: 1)

        buttons = subject.buttons
        expect(buttons.count).to eq 1
        expect(buttons.last).to match({ type: "button", index: 1, sub_type: "quick_reply" })
      end

      it "uses default position when index not provided" do
        subject.add_quick_reply_button

        buttons = subject.buttons
        expect(buttons.count).to eq 1
        expect(buttons.last).to match({ type: "button", index: 0, sub_type: "quick_reply" })
      end

      it "increments position for multiple buttons" do
        subject.add_quick_reply_button
        subject.add_quick_reply_button

        buttons = subject.buttons
        expect(buttons.count).to eq 2
        expect(buttons[0]).to match({ type: "button", index: 0, sub_type: "quick_reply" })
        expect(buttons[1]).to match({ type: "button", index: 1, sub_type: "quick_reply" })
      end
    end
  end

  describe "#add_dynamic_url_button" do
    context "with block" do
      it "sets custom index when provided" do
        subject.add_dynamic_url_button do |button|
          button.index = 1
          button.text = "url_suffix"
        end

        buttons = subject.buttons
        expect(buttons.count).to eq 1
        expect(buttons.last).to match({ type: "button", index: 1, sub_type: "url",
                                        parameters: [{ type: "text", text: "url_suffix" }] })
      end

      it "uses default position when index not provided" do
        subject.add_dynamic_url_button do |button|
          button.text = "url_suffix"
        end

        buttons = subject.buttons
        expect(buttons.count).to eq 1
        expect(buttons.last).to match({ type: "button", index: 0, sub_type: "url",
                                        parameters: [{ type: "text", text: "url_suffix" }] })
      end
    end

    context "without using block" do
      it "sets custom index when provided" do
        subject.add_dynamic_url_button(index: 1, text: "url_suffix")

        buttons = subject.buttons
        expect(buttons.count).to eq 1
        expect(buttons.last).to match({ type: "button", index: 1, sub_type: "url",
                                        parameters: [{ type: "text", text: "url_suffix" }] })
      end

      it "uses default position when index not provided" do
        subject.add_dynamic_url_button(text: "url_suffix")

        buttons = subject.buttons
        expect(buttons.count).to eq 1
        expect(buttons.last).to match({ type: "button", index: 0, sub_type: "url",
                                        parameters: [{ type: "text", text: "url_suffix" }] })
      end

      it "increments position for multiple buttons" do
        subject.add_dynamic_url_button(text: "url1")
        subject.add_dynamic_url_button(text: "url2")

        buttons = subject.buttons
        expect(buttons.count).to eq 2
        expect(buttons[0]).to match({ type: "button", index: 0, sub_type: "url",
                                      parameters: [{ type: "text", text: "url1" }] })
        expect(buttons[1]).to match({ type: "button", index: 1, sub_type: "url",
                                      parameters: [{ type: "text", text: "url2" }] })
      end
    end
  end

  describe "#add_copy_code_button" do
    context "with block" do
      it "sets custom index when provided" do
        subject.add_copy_code_button do |button|
          button.index = 1
          button.coupon_code = "SAVE20"
        end

        buttons = subject.buttons
        expect(buttons.count).to eq 1
        expect(buttons.last).to match({ type: "button", index: 1, sub_type: "copy_code",
                                        parameters: [{ type: "coupon_code", coupon_code: "SAVE20" }] })
      end

      it "uses default position when index not provided" do
        subject.add_copy_code_button do |button|
          button.coupon_code = "SAVE20"
        end

        buttons = subject.buttons
        expect(buttons.count).to eq 1
        expect(buttons.last).to match({ type: "button", index: 0, sub_type: "copy_code",
                                        parameters: [{ type: "coupon_code", coupon_code: "SAVE20" }] })
      end
    end

    context "without using block" do
      it "sets custom index when provided" do
        subject.add_copy_code_button(index: 1, coupon_code: "SAVE20")

        buttons = subject.buttons
        expect(buttons.count).to eq 1
        expect(buttons.last).to match({ type: "button", index: 1, sub_type: "copy_code",
                                        parameters: [{ type: "coupon_code", coupon_code: "SAVE20" }] })
      end

      it "uses default position when index not provided" do
        subject.add_copy_code_button(coupon_code: "SAVE20")

        buttons = subject.buttons
        expect(buttons.count).to eq 1
        expect(buttons.last).to match({ type: "button", index: 0, sub_type: "copy_code",
                                        parameters: [{ type: "coupon_code", coupon_code: "SAVE20" }] })
      end

      it "increments position for multiple buttons" do
        subject.add_copy_code_button(coupon_code: "SAVE20")
        subject.add_copy_code_button(coupon_code: "SAVE30")

        buttons = subject.buttons
        expect(buttons.count).to eq 2
        expect(buttons[0]).to match({ type: "button", index: 0, sub_type: "copy_code",
                                      parameters: [{ type: "coupon_code", coupon_code: "SAVE20" }] })
        expect(buttons[1]).to match({ type: "button", index: 1, sub_type: "copy_code",
                                      parameters: [{ type: "coupon_code", coupon_code: "SAVE30" }] })
      end
    end
  end

  describe "#add_auth_code_button" do
    context "with block" do
      it "sets custom index when provided" do
        subject.add_auth_code_button do |button|
          button.index = 1
          button.text = "auth_url"
        end

        buttons = subject.buttons
        expect(buttons.count).to eq 1
        expect(buttons.last).to match({ type: "button", index: 1, sub_type: "url",
                                        parameters: [{ type: "text", text: "auth_url" }] })
      end

      it "uses default position when index not provided" do
        subject.add_auth_code_button do |button|
          button.text = "auth_url"
        end

        buttons = subject.buttons
        expect(buttons.count).to eq 1
        expect(buttons.last).to match({ type: "button", index: 0, sub_type: "url",
                                        parameters: [{ type: "text", text: "auth_url" }] })
      end
    end

    context "without using block" do
      it "sets custom index when provided" do
        subject.add_auth_code_button(index: 1, text: "auth_url")

        buttons = subject.buttons
        expect(buttons.count).to eq 1
        expect(buttons.last).to match({ type: "button", index: 1, sub_type: "url",
                                        parameters: [{ type: "text", text: "auth_url" }] })
      end

      it "uses default position when index not provided" do
        subject.add_auth_code_button(text: "auth_url")

        buttons = subject.buttons
        expect(buttons.count).to eq 1
        expect(buttons.last).to match({ type: "button", index: 0, sub_type: "url",
                                        parameters: [{ type: "text", text: "auth_url" }] })
      end

      it "increments position for multiple buttons" do
        subject.add_auth_code_button(text: "auth1")
        subject.add_auth_code_button(text: "auth2")

        buttons = subject.buttons
        expect(buttons.count).to eq 2
        expect(buttons[0]).to match({ type: "button", index: 0, sub_type: "url",
                                      parameters: [{ type: "text", text: "auth1" }] })
        expect(buttons[1]).to match({ type: "button", index: 1, sub_type: "url",
                                      parameters: [{ type: "text", text: "auth2" }] })
      end
    end
  end

  describe "#add_voice_call_button" do
    context "with block" do
      it "sets custom index when provided" do
        subject.add_voice_call_button do |button|
          button.index = 1
        end

        buttons = subject.buttons
        expect(buttons.count).to eq 1
        expect(buttons.last).to match({ type: "button", index: 1, sub_type: "voice_call" })
      end

      it "uses default position when index not provided" do
        subject.add_voice_call_button do |button|
        end

        buttons = subject.buttons
        expect(buttons.count).to eq 1
        expect(buttons.last).to match({ type: "button", index: 0, sub_type: "voice_call" })
      end
    end

    context "without using block" do
      it "sets custom index when provided" do
        subject.add_voice_call_button(index: 1)

        buttons = subject.buttons
        expect(buttons.count).to eq 1
        expect(buttons.last).to match({ type: "button", index: 1, sub_type: "voice_call" })
      end

      it "uses default position when index not provided" do
        subject.add_voice_call_button

        buttons = subject.buttons
        expect(buttons.count).to eq 1
        expect(buttons.last).to match({ type: "button", index: 0, sub_type: "voice_call" })
      end

      it "increments position for multiple buttons" do
        subject.add_voice_call_button
        subject.add_voice_call_button

        buttons = subject.buttons
        expect(buttons.count).to eq 2
        expect(buttons[0]).to match({ type: "button", index: 0, sub_type: "voice_call" })
        expect(buttons[1]).to match({ type: "button", index: 1, sub_type: "voice_call" })
      end
    end
  end

  describe "#set_location_header" do
    context "with id, using block" do
      it do
        expect do
          subject.set_location_header do |location|
            expect(location).to be_a Warb::Resources::Location
            expect(location).to eq subject.header
          end
        end.to change(subject, :header).from(NilClass).to(Warb::Resources::Location)
      end
    end

    context "with link, without using block" do
      it do
        expect do
          location = subject.set_location_header

          expect(location).to be_a Warb::Resources::Location
          expect(location).to eq subject.header
        end.to change(subject, :header).from(NilClass).to(Warb::Resources::Location)
      end
    end
  end

  describe "#add_button" do
    context "with block" do
      it do
        instance = Warb::Components::QuickReplyButton.new
        subject.add_button(instance) { |button| button.index = 0 }

        expect(subject.buttons.count).to eq 1
        expect(subject.buttons.last).to match(instance.to_h)
      end
    end

    context "without using block" do
      it do
        instance = Warb::Components::QuickReplyButton.new(index: 0)
        subject.add_button(instance)

        expect(subject.buttons.count).to eq 1
        expect(subject.buttons.last).to match(instance.to_h)
      end
    end
  end

  describe "#build_payload" do
    context "with minimal template" do
      before do
        allow(subject).to receive_messages(
          name: "template_name",
          language: Warb::Language::ENGLISH_US,
          resources: nil,
          header: nil,
          buttons: []
        )
      end

      it "builds basic template structure" do
        expect(subject.build_payload).to eq({
          type: "template",
          template: {
            name: "template_name",
            language: {
              code: Warb::Language::ENGLISH_US
            },
            components: []
          }
        })
      end
    end

    context "with header only" do
      let(:text_header) { Warb::Resources::Text.new(content: "Header Text") }

      before do
        allow(subject).to receive_messages(
          name: "template_name",
          language: Warb::Language::ENGLISH_US,
          resources: nil,
          header: text_header,
          buttons: []
        )
        allow(text_header).to receive(:build_header).and_return({
          type: "text",
          text: "Header Text"
        })
      end

      it "includes header component" do
        expect(subject.build_payload).to eq({
          type: "template",
          template: {
            name: "template_name",
            language: {
              code: Warb::Language::ENGLISH_US
            },
            components: [
              {
                type: "header",
                parameters: [
                  {
                    type: "text",
                    text: "Header Text"
                  }
                ]
              }
            ]
          }
        })
      end
    end

    context "with body parameters only" do
      let(:text_param) { Warb::Resources::Text.new(content: "Body Text") }

      before do
        allow(subject).to receive_messages(
          name: "template_name",
          language: Warb::Language::ENGLISH_US,
          resources: [text_param],
          header: nil,
          buttons: []
        )
        allow(text_param).to receive(:build_template_positional_parameter).and_return({
          type: "text",
          text: "Body Text"
        })
      end

      it "includes body component with positional parameters" do
        expect(subject.build_payload).to eq({
          type: "template",
          template: {
            name: "template_name",
            language: {
              code: Warb::Language::ENGLISH_US
            },
            components: [
              {
                type: "body",
                parameters: [
                  {
                    type: "text",
                    text: "Body Text"
                  }
                ]
              }
            ]
          }
        })
      end
    end

    context "with named body parameters" do
      let(:text_param) { Warb::Resources::Text.new(content: "Body Text") }

      before do
        allow(subject).to receive_messages(
          name: "template_name",
          language: Warb::Language::ENGLISH_US,
          resources: { "param_name" => text_param },
          header: nil,
          buttons: []
        )
        allow(text_param).to receive(:build_template_named_parameter).with("param_name").and_return({
          type: "text",
          parameter_name: "param_name",
          text: "Body Text"
        })
      end

      it "includes body component with named parameters" do
        expect(subject.build_payload).to eq({
          type: "template",
          template: {
            name: "template_name",
            language: {
              code: Warb::Language::ENGLISH_US
            },
            components: [
              {
                type: "body",
                parameters: [
                  {
                    type: "text",
                    parameter_name: "param_name",
                    text: "Body Text"
                  }
                ]
              }
            ]
          }
        })
      end
    end

    context "with buttons only" do
      let(:button_payload) { { type: "button", index: 0, sub_type: "quick_reply" } }

      before do
        allow(subject).to receive_messages(
          name: "template_name",
          language: Warb::Language::ENGLISH_US,
          resources: nil,
          header: nil,
          buttons: [button_payload]
        )
      end

      it "includes button components" do
        expect(subject.build_payload).to eq({
          type: "template",
          template: {
            name: "template_name",
            language: {
              code: Warb::Language::ENGLISH_US
            },
            components: [
              {
                type: "button",
                index: 0,
                sub_type: "quick_reply"
              }
            ]
          }
        })
      end
    end
  end
end
