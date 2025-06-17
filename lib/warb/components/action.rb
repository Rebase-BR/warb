module Warb
  module Components
    class Row
      attr_accessor :title, :description

      def initialize(title: nil, description: nil)
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
      attr_accessor :title, :rows

      def initialize(title: nil, rows: [])
        @title = title
        @rows = rows
      end

      def add_row(**args, &block)
        row = Row.new(**args)

        @rows << row

        block_given? ? row.tap(&block) : row
      end

      def to_h
        {
          title: @title,
          rows: @rows.map.with_index do |row, index|
            row_title = row.title.slice(0, 10)
            title = row_title.normalize.gsub(/\s/, "").downcase
            id = "#{title}_#{index}"

            row.to_h.merge(id: id)
          end
        }
      end
    end

    class ListAction
      attr_accessor :button_text, :sections

      def initialize(button_text: nil, sections: [])
        @button_text = button_text
        @sections = sections
      end

      def add_section(**args, &block)
        section = Section.new(**args)

        @sections << section

        block_given? ? section.tap(&block) : section
      end

      def to_h
        {
          button: @button_text,
          sections: @sections.map(&:to_h)
        }
      end
    end

    class ReplyButtonAction
      attr_accessor :buttons_texts

      def initialize(buttons_texts: nil)
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
      attr_accessor :button_text, :url

      def initialize(button_text: nil, url: nil)
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
