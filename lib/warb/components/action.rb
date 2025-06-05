module Warb
  module Components
    class Row
      attr_accessor :title, :description

      def initialize(title: nil, description: nil)
        @title = title
        @description = description
      end

      def to_h
        check_for_errors

        {
          title: @title,
          description: @description
        }
      end

      private

      def check_for_errors
        errors = []

        check_title_errors(errors)
        check_description_errors(errors)

        raise Warb::Error.new(errors: errors) unless errors.empty?
      end

      def check_title_errors(errors)
        if title.nil? || title.empty?
          errors << I18n.t("errors.required", attr: "Title")
        elsif title.length > 24
          errors << I18n.t("errors.too_long", attr: "Title", length: 24)
        end
      end

      def check_description_errors(errors)
        errors << I18n.t("errors.too_long", attr: "Description", length: 72) if description && description.length > 72
      end
    end

    class Section
      attr_accessor :title, :rows

      def initialize(title: nil, rows: [])
        @title = title
        @rows = rows
      end

      def add_row(**args)
        Row.new(**args).tap { |row| @rows << row }
      end

      def to_h
        check_for_errors

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

      private

      def check_for_errors
        errors = []

        check_title_errors(errors)
        check_rows_errors(errors)

        raise Warb::Error.new(errors: errors) unless errors.empty?
      end

      def check_title_errors(errors)
        return if title.nil? || title.empty?

        errors << I18n.t("errors.too_long", attr: "Title", length: 24) if title.length > 24
      end

      def check_rows_errors(errors)
        if rows.empty?
          errors << I18n.t("errors.too_few", attr: "Rows", count: 1)
        else
          rows_count = rows.count

          errors << I18n.t("errors.too_many", attr: "Rows", count: 10) if rows_count > 10
          errors << I18n.t("errors.not_unique", attr: "Rows title") if rows_count != rows.uniq(&:title).count
        end
      end
    end

    class ListAction
      attr_accessor :button_text, :sections

      def initialize(button_text: nil, sections: [])
        @button_text = button_text
        @sections = sections
      end

      def add_section(**args)
        Section.new(**args).tap { |section| @sections << section }
      end

      def to_h
        check_for_errors

        {
          button: @button_text,
          sections: @sections.map(&:to_h)
        }
      end

      private

      def check_for_errors
        errors = []

        check_button_text_errors(errors)
        check_sections_errors(errors)

        raise Warb::Error.new(errors: errors) unless errors.empty?
      end

      def check_button_text_errors(errors)
        if button_text.nil? || button_text.empty?
          errors << I18n.t("errors.required", attr: "Button Text")
        elsif button_text.length > 20
          errors << I18n.t("errors.too_long", attr: "Button Text", length: 20)
        end
      end

      def check_sections_errors(errors)
        if sections.empty?
          errors << I18n.t("errors.too_few", attr: "Sections", count: 1)
        else
          errors << I18n.t("errors.too_many", attr: "Sections", count: 10) if sections.count > 10

          check_sections_titles_errors(errors)
        end
      end

      def check_sections_titles_errors(errors)
        return unless sections.count > 1
        return unless sections.any? { |section| section.title.nil? || section.title.empty? }

        errors << I18n.t("errors.required_if_multiple_sections", attr: "Section Title")
      end
    end

    class ReplyButtonAction
      attr_accessor :buttons_texts

      def initialize(buttons_texts: nil)
        @buttons_texts = buttons_texts
      end

      def to_h
        check_errors

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

      private

      def check_errors
        errors = []

        check_buttons_texts_errors(errors)

        raise Warb::Error.new(errors: errors) unless errors.empty?
      end

      def check_buttons_texts_errors(errors)
        if buttons_texts.empty?
          errors << I18n.t("errors.too_few", attr: "Buttons Texts", count: 1)
        else
          buttons_count = buttons_texts.count
          unique_buttons_count = buttons_texts.uniq.count

          errors << I18n.t("errors.too_many", attr: "Buttons Texts", count: 3) if buttons_count > 3
          errors << I18n.t("errors.not_unique", attr: "Button Text") if buttons_count != unique_buttons_count
        end
      end
    end

    class CTAAction
      attr_accessor :button_text, :url

      def initialize(button_text: nil, url: nil)
        @button_text = button_text
        @url = url
      end

      def to_h
        check_errors

        {
          name: "cta_url",
          parameters: {
            display_text: @button_text,
            url: @url
          }
        }
      end

      private

      def check_errors
        errors = []

        check_display_text_errors(errors)
        check_url_errors(errors)

        raise Warb::Error.new(errors: errors) unless errors.empty?
      end

      def check_display_text_errors(errors)
        if button_text.nil? || button_text.empty?
          errors << I18n.t("errors.required", attr: "Button Text")
        elsif button_text.length > 20
          errors << I18n.t("errors.too_long", attr: "Button Text", length: 20)
        end
      end

      def check_url_errors(errors)
        return unless url.nil? || url.empty?

        errors << I18n.t("errors.required", attr: "URL")
      end
    end
  end
end
