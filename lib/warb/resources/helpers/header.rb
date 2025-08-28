module Warb
  module Resources
    module Helpers
      module Header
        def add_text_header(content: nil, message: nil, text: nil, parameter_name: nil, &block)
          add_header(Warb::Resources::Text.new(content:, message:, text:, parameter_name:), &block)
        end

        def add_image_header(media_id: nil, link: nil, &block)
          add_header(Warb::Resources::Image.new(media_id:, link:), &block)
        end

        def add_document_header(media_id: nil, link: nil, filename: nil, &block)
          add_header(Warb::Resources::Document.new(media_id:, link:, filename:), &block)
        end

        def add_video_header(media_id: nil, link: nil, &block)
          add_header(Warb::Resources::Video.new(media_id:, link:), &block)
        end

        def add_location_header(latitude: nil, longitude: nil, address: nil, name: nil, &block)
          add_header(Warb::Resources::Location.new(latitude:, longitude:, address:, name:), &block)
        end

        private

        def add_header(instance, &)
          @header = instance

          block_given? ? @header.tap(&) : @header
        end
      end
    end
  end
end
