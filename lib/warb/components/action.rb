module Warb
  module Components
    class Row
      def initialize(title:, description:)
        @title = title
        @description = description
      end

      def to_h
        {
          title: @title,
          description: @description
        }
      end
    end

    class Section
      def initialize(title:, rows:)
        @title = title
        @rows = rows.map(&:to_h)
        @rows.each_with_index do |row, index|
          title = row[:title].normalize.gsub(/\s/, "").downcase

          "#{title}_#{index}"
        end
      end

      def to_h
        {
          title: @title,
          rows: @rows
        }
      end
    end

    class ListAction
      def initialize(button_text:, sections:)
        @button_text = button_text
        @sections = sections
      end

      def to_h
        {
          button: @button_text,
          sections: @sections.map(&:to_h)
        }
      end
    end

    class ReplyButtonAction
      def initialize(buttons_texts:)
        @buttons_texts = buttons_texts
      end

      def to_h
        {
          buttons: @buttons_texts.map.with_index do |button_text, index|
            text = button_text.normalize.gsub(/\s/, "").downcase
            id = "#{text}_#{index}"

            {
              type: "reply",
              reply: {
                id: id,
                title: button_text
              }
            }
          end
        }
      end
    end

    class CTAAction
      def initialize(button_text:, url:)
        @button_text = button_text
        @url = url
      end

      def to_h
        {
          name: "cta_url",
          parameters: {
            display_text: @button_text,
            url: @url
          }
        }
      end
    end
  end
end
