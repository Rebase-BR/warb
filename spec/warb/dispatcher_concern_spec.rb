# frozen_string_literal: true

RSpec.describe Warb::DispatcherConcern do
  let(:global_client) { Warb.client }
  let(:local_client_dispatcher) { Warb::Client.new }

  describe "#message" do
    context "without a previous call, from within a client instance" do
      it do
        expect(Warb::Dispatcher).to receive(:new).with(Warb::Resources::Text, local_client_dispatcher)
        expect(Warb).not_to receive(:client)

        local_client_dispatcher.message
      end
    end

    context "with a previous call, from within Warb module" do
      before { global_client.message }

      it do
        expect(Warb).not_to receive(:client)
        expect(Warb::Dispatcher).not_to receive(:new)

        global_client.message
      end
    end
  end

  describe "#image" do
    context "without a previous call, from within Warb module" do
      it do
        expect(Warb).to receive(:client).and_call_original
        expect(Warb::MediaDispatcher).to receive(:new).with(Warb::Resources::Image, global_client)

        global_client.image
      end
    end

    context "with a previous call, from within a client instance" do
      before { local_client_dispatcher.image }

      it do
        expect(Warb).not_to receive(:client)
        expect(Warb::MediaDispatcher).not_to receive(:new)

        local_client_dispatcher.image
      end
    end
  end

  describe "#video" do
    context "without a previous call, from within a client instance" do
      it do
        expect(Warb).not_to receive(:client)
        expect(Warb::MediaDispatcher).to receive(:new).with(Warb::Resources::Video, local_client_dispatcher)

        local_client_dispatcher.video
      end
    end

    context "with a previous call, from withing Warb module" do
      before { global_client.video }

      it do
        expect(Warb).not_to receive(:client)
        expect(Warb::MediaDispatcher).not_to receive(:new)

        global_client.video
      end
    end
  end

  describe "#audio" do
    context "without a previous call, from within Warb module" do
      it do
        expect(Warb).to receive(:client).and_call_original
        expect(Warb::MediaDispatcher).to receive(:new).with(Warb::Resources::Audio, global_client)

        global_client.audio
      end
    end

    context "with a previous call, from within a client instance" do
      before { local_client_dispatcher.audio }

      it do
        expect(Warb).not_to receive(:client)
        expect(Warb::MediaDispatcher).not_to receive(:new)

        local_client_dispatcher.audio
      end
    end
  end

  describe "#document" do
    context "without a previous call, from within a client instance" do
      it do
        expect(Warb::MediaDispatcher).to receive(:new).with(Warb::Resources::Document, local_client_dispatcher)
        expect(Warb).not_to receive(:client)

        local_client_dispatcher.document
      end
    end

    context "with a previous call, from within Warb module" do
      before { global_client.document }

      it do
        expect(Warb).not_to receive(:client)
        expect(Warb::MediaDispatcher).not_to receive(:new)

        global_client.document
      end
    end
  end

  describe "#location" do
    context "without a previous call, from within Warb module" do
      it do
        expect(Warb).to receive(:client).and_call_original
        expect(Warb::Dispatcher).to receive(:new).with(Warb::Resources::Location, global_client)

        global_client.location
      end
    end

    context "with a previous call, from within a client instance" do
      before { local_client_dispatcher.location }

      it do
        expect(Warb).not_to receive(:client)
        expect(Warb::Dispatcher).not_to receive(:new)

        local_client_dispatcher.location
      end
    end
  end

  describe "#location_request" do
    context "without a previous call, from within a client instance" do
      it do
        expect(Warb::Dispatcher).to receive(:new).with(Warb::Resources::LocationRequest, local_client_dispatcher)
        expect(Warb).not_to receive(:client)

        local_client_dispatcher.location_request
      end
    end

    context "with a previous call, from within Warb module" do
      before { global_client.location_request }

      it do
        expect(Warb).not_to receive(:client)
        expect(Warb::Dispatcher).not_to receive(:new)

        global_client.location_request
      end
    end
  end

  describe "#interactive_reply_button" do
    context "without a previous call, from within Warb module" do
      it do
        expect(Warb).to receive(:client).and_call_original
        expect(Warb::Dispatcher).to receive(:new).with(Warb::Resources::InteractiveReplyButton, global_client)

        global_client.interactive_reply_button
      end
    end

    context "with a previous call, from within a client instance" do
      before { local_client_dispatcher.interactive_reply_button }

      it do
        expect(Warb).not_to receive(:client)
        expect(Warb::Dispatcher).not_to receive(:new)

        local_client_dispatcher.interactive_reply_button
      end
    end
  end

  describe "#interactive_list" do
    context "without a previous call, from within a client instance" do
      it do
        expect(Warb::Dispatcher).to receive(:new).with(Warb::Resources::InteractiveList, local_client_dispatcher)
        expect(Warb).not_to receive(:client)

        local_client_dispatcher.interactive_list
      end
    end

    context "with a previous call, from within Warb module" do
      before { global_client.interactive_list }

      it do
        expect(Warb).not_to receive(:client)
        expect(Warb::Dispatcher).not_to receive(:new)

        global_client.interactive_list
      end
    end
  end

  describe "#interactive_call_to_action_url" do
    context "without a previous call, from within Warb module" do
      it do
        expect(Warb).to receive(:client).and_call_original
        expect(Warb::Dispatcher).to receive(:new).with(Warb::Resources::InteractiveCallToActionUrl, global_client)

        global_client.interactive_call_to_action_url
      end
    end

    context "with a previous call, from within a client instance" do
      before { local_client_dispatcher.interactive_call_to_action_url }

      it do
        expect(Warb).not_to receive(:client)
        expect(Warb::Dispatcher).not_to receive(:new)

        local_client_dispatcher.interactive_call_to_action_url
      end
    end
  end

  describe "#sticker" do
    context "without a previous call, from within Warb module" do
      it do
        expect(Warb).to receive(:client).and_call_original
        expect(Warb::Dispatcher).to receive(:new).with(Warb::Resources::Sticker, global_client)

        global_client.sticker
      end
    end

    context "with a previous call, from within a client instance" do
      before { local_client_dispatcher.sticker }

      it do
        expect(Warb).not_to receive(:client)
        expect(Warb::Dispatcher).not_to receive(:new)

        local_client_dispatcher.sticker
      end
    end
  end

  describe "#reaction" do
    context "without a previous call, from within Warb module" do
      it do
        expect(Warb).to receive(:client).and_call_original
        expect(Warb::Dispatcher).to receive(:new).with(Warb::Resources::Reaction, global_client)

        global_client.reaction
      end
    end

    context "with a previous call, from within a client instance" do
      before { local_client_dispatcher.reaction }

      it do
        expect(Warb).not_to receive(:client)
        expect(Warb::Dispatcher).not_to receive(:new)

        local_client_dispatcher.reaction
      end
    end
  end

  describe "#indicator" do
    context "without a previous call, from within a client instance" do
      it do
        expect(Warb).not_to receive(:client)
        expect(Warb::IndicatorDispatcher).to receive(:new)

        local_client_dispatcher.indicator
      end
    end

    context "with a previous call, from within Warb instance" do
      before { Warb.indicator }

      it do
        expect(Warb).not_to receive(:client)
        expect(Warb::IndicatorDispatcher).not_to receive(:new)

        Warb.indicator
      end
    end
  end
end
