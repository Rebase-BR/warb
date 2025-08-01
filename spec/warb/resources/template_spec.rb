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

  describe "#build_payload" do
    context "with positional parameters" do
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

    context "with image header" do
      let(:image) { Warb::Resources::Image.new(media_id: "media_id") }

      before do
        allow(subject).to receive_messages(
          name: "template_name",
          language: "pt_BR",
          header: image
        )
      end

      it do
        expect(image).to receive(:build_header).and_call_original

        expect(subject.build_payload).to eq(
          {
            type: "template",
            template: {
              name: "template_name",
              language: { code: "pt_BR" },
              components: [
                {
                  type: "header",
                  parameters: [
                    {
                      type: "image",
                      image: {
                        id: "media_id",
                        link: nil
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

    context "with document header" do
      let(:document) { Warb::Resources::Document.new(media_id: "media_id", filename: "document.pdf") }

      before do
        allow(subject).to receive_messages(
          name: "template_name",
          language: "pt_BR",
          header: document
        )
      end

      it do
        expect(document).to receive(:build_header).and_call_original

        expect(subject.build_payload).to eq(
          {
            type: "template",
            template: {
              name: "template_name",
              language: { code: "pt_BR" },
              components: [
                {
                  type: "header",
                  parameters: [
                    {
                      type: "document",
                      document: {
                        id: "media_id",
                        link: nil,
                        filename: "document.pdf"
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

    context "with video header" do
      let(:video) { Warb::Resources::Video.new(media_id: "media_id") }

      before do
        allow(subject).to receive_messages(
          name: "template_name",
          language: "pt_BR",
          header: video
        )
      end

      it do
        expect(video).to receive(:build_header).and_call_original

        expect(subject.build_payload).to eq(
          {
            type: "template",
            template: {
              name: "template_name",
              language: { code: "pt_BR" },
              components: [
                {
                  type: "header",
                  parameters: [
                    {
                      type: "video",
                      video: {
                        id: "media_id",
                        link: nil
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

    context "with location header" do
      let(:location) { Warb::Resources::Location.new(latitude: "latitude", longitude: "longitude") }

      before do
        allow(subject).to receive_messages(
          name: "template_name",
          language: "pt_BR",
          header: location
        )
      end

      it do
        expect(location).to receive(:build_header).and_call_original

        expect(subject.build_payload).to eq(
          {
            type: "template",
            template: {
              name: "template_name",
              language: { code: "pt_BR" },
              components: [
                {
                  type: "header",
                  parameters: [
                    {
                      type: "location",
                      location: {
                        latitude: "latitude",
                        longitude: "longitude",
                        address: nil,
                        name: nil
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

    context "with text header" do
      before do
        allow(subject).to receive_messages(
          name: "template_name",
          language: Warb::Language::PORTUGUESE_BR,
          header: text
        )
      end

      context "with positional parameter" do
        let(:text) { Warb::Resources::Text.new(content: "John") }

        it do
          expect(subject.build_payload).to eq(
            {
              type: "template",
              template: {
                name: "template_name",
                language: { code: "pt_BR" },
                components: [
                  {
                    type: "header",
                    parameters: [
                      {
                        type: "text",
                        text: "John"
                      }
                    ]
                  }
                ]
              }
            }
          )
        end
      end

      context "with named parameter" do
        let(:text) { Warb::Resources::Text.new(text: "John", parameter_name: "customer_name") }

        it do
          expect(subject.build_payload).to eq(
            {
              type: "template",
              template: {
                name: "template_name",
                language: { code: "pt_BR" },
                components: [
                  {
                    type: "header",
                    parameters: [
                      {
                        type: "text",
                        text: "John",
                        parameter_name: "customer_name"
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

    context "with quick reply button" do
      before do
        allow(subject).to receive_messages(
          name: "template_name",
          language: "en_US",
          buttons: [
            {
              type: "button",
              sub_type: "quick_reply",
              index: "0"
            }
          ]
        )
      end

      it do
        expect(subject.build_payload).to eq(
          {
            type: "template",
            template: {
              name: "template_name",
              language: { code: "en_US" },
              components: [
                {
                  type: "button",
                  sub_type: "quick_reply",
                  index: "0"
                }
              ]
            }
          }
        )
      end
    end

    context "with dynamic url button" do
      before do
        allow(subject).to receive_messages(
          name: "template_name",
          language: "en_US",
          buttons: [
            {
              type: "button",
              sub_type: "url",
              index: "0",
              parameters: [
                {
                  type: "text",
                  text: "url_suffix"
                }
              ]
            }
          ]
        )
      end

      it do
        expect(subject.build_payload).to eq(
          {
            type: "template",
            template: {
              name: "template_name",
              language: { code: "en_US" },
              components: [
                {
                  type: "button",
                  sub_type: "url",
                  index: "0",
                  parameters: [
                    {
                      type: "text",
                      text: "url_suffix"
                    }
                  ]
                }
              ]
            }
          }
        )
      end
    end

    context "with copy code button" do
      before do
        allow(subject).to receive_messages(
          name: "template_name",
          language: "en_US",
          buttons: [
            {
              type: "button",
              sub_type: "copy_code",
              index: "0",
              parameters: [
                {
                  type: "coupon_code",
                  coupon_code: "SAVE20"
                }
              ]
            }
          ]
        )
      end

      it do
        expect(subject.build_payload).to eq(
          {
            type: "template",
            template: {
              name: "template_name",
              language: { code: "en_US" },
              components: [
                {
                  type: "button",
                  sub_type: "copy_code",
                  index: "0",
                  parameters: [
                    {
                      type: "coupon_code",
                      coupon_code: "SAVE20"
                    }
                  ]
                }
              ]
            }
          }
        )
      end
    end

    context "with voice call button" do
      before do
        allow(subject).to receive_messages(
          name: "template_name",
          language: "en_US",
          buttons: [
            {
              type: "button",
              sub_type: "voice_call",
              index: "0"
            }
          ]
        )
      end

      it do
        expect(subject.build_payload).to eq(
          {
            type: "template",
            template: {
              name: "template_name",
              language: { code: "en_US" },
              components: [
                {
                  type: "button",
                  sub_type: "voice_call",
                  index: "0"
                }
              ]
            }
          }
        )
      end
    end

    context "with multiple buttons" do
      before do
        allow(subject).to receive_messages(
          name: "template_name",
          language: "en_US",
          buttons: [
            {
              type: "button",
              sub_type: "quick_reply",
              index: "0"
            },
            {
              type: "button",
              sub_type: "url",
              index: "1",
              parameters: [
                {
                  type: "text",
                  text: "url_suffix"
                }
              ]
            },
            {
              type: "button",
              sub_type: "copy_code",
              index: "2",
              parameters: [
                {
                  type: "coupon_code",
                  coupon_code: "SAVE20"
                }
              ]
            }
          ]
        )
      end

      it do
        expect(subject.build_payload).to eq(
          {
            type: "template",
            template: {
              name: "template_name",
              language: { code: "en_US" },
              components: [
                {
                  type: "button",
                  sub_type: "quick_reply",
                  index: "0"
                },
                {
                  type: "button",
                  sub_type: "url",
                  index: "1",
                  parameters: [
                    {
                      type: "text",
                      text: "url_suffix"
                    }
                  ]
                },
                {
                  type: "button",
                  sub_type: "copy_code",
                  index: "2",
                  parameters: [
                    {
                      type: "coupon_code",
                      coupon_code: "SAVE20"
                    }
                  ]
                }
              ]
            }
          }
        )
      end
    end

    context "with header, body parameters and buttons" do
      let(:image) { Warb::Resources::Image.new(media_id: "media_id") }

      before do
        allow(subject).to receive_messages(
          name: "template_name",
          language: "en_US",
          header: image,
          resources: [
            Warb::Resources::Text.new(content: "First Param")
          ],
          buttons: [
            {
              type: "button",
              sub_type: "quick_reply",
              index: "0"
            }
          ]
        )
      end

      it do
        expect(image).to receive(:build_header).and_call_original

        expect(subject.build_payload).to eq(
          {
            type: "template",
            template: {
              name: "template_name",
              language: { code: "en_US" },
              components: [
                {
                  type: "header",
                  parameters: [
                    {
                      type: "image",
                      image: {
                        id: "media_id",
                        link: nil
                      }
                    }
                  ]
                },
                {
                  type: "body",
                  parameters: [
                    {
                      type: "text",
                      text: "First Param"
                    }
                  ]
                },
                {
                  type: "button",
                  sub_type: "quick_reply",
                  index: "0"
                }
              ]
            }
          }
        )
      end
    end
  end
end
