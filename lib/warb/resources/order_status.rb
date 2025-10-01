# frozen_string_literal: true

module Warb
  module Resources
    class OrderStatus < Resource
      include Helpers::Header

      attr_accessor :header, :body, :footer,
                    :reference_id, :status, :description, :payment

      ALLOWED_ORDER_STATUSES = %w[
        pending
        processing
        partially-shipped
        shipped
        completed
        canceled
      ].freeze

      ALLOWED_PAYMENT_STATUSES = %w[
        pending
        captured
        failed
      ].freeze

      def build_payload
        validate!

        {
          type: 'interactive',
          interactive: build_interactive
        }
      end

      private

      def build_interactive
        interactive = {
          type: 'order_status',
          action: {
            name: 'review_order',
            parameters: build_parameters
          }
        }

        header = resolve(:header)
        if header.is_a?(Hash)
          interactive[:header] = header
        elsif header.respond_to?(:build_header)
          interactive[:header] = header.build_header
        end

        body_text = resolve(:body)
        interactive[:body] = { text: body_text }

        footer = resolve(:footer)
        interactive[:footer] = { text: footer } unless blank?(footer)

        interactive
      end

      def build_parameters
        {
          reference_id: resolve(:reference_id),
          order: build_order
        }.tap do |params|
          pay = normalize_payment(resolve(:payment))
          params[:payment] = pay unless pay.nil?
        end
      end

      def build_order
        {
          status: normalize_order_status(resolve(:status)),
          description: normalize_order_description(resolve(:description))
        }.delete_if { |_, v| blank?(v) }
      end

      def validate!
        validates :body,         required: true
        ensure_string!(resolve(:body), 'body.text')
        ensure_max_len!(resolve(:body), 1024, 'body.text')

        footer = resolve(:footer)
        unless blank?(footer)
          ensure_string!(footer, 'footer.text')
          ensure_max_len!(footer, 60, 'footer.text')
        end

        validates :reference_id, required: true
        ensure_string!(resolve(:reference_id), 'parameters.reference_id')

        validates :status, required: true
        normalize_order_status(resolve(:status))

        description = resolve(:description)
        unless blank?(description)
          ensure_string!(description, 'parameters.order.description')
          ensure_max_len!(description, 120, 'parameters.order.description')
        end

        normalize_payment(resolve(:payment)) unless blank?(resolve(:payment))
      end

      def normalize_order_status(val)
        ensure_string!(val, 'parameters.order.status')
        status = val.to_s
        unless ALLOWED_ORDER_STATUSES.include?(status)
          raise ArgumentError, "parameters.order.status must be one of: #{ALLOWED_ORDER_STATUSES.join(', ')}"
        end
        status
      end

      def normalize_order_description(val)
        return nil if blank?(val)
        ensure_string!(val, 'parameters.order.description')
        ensure_max_len!(val, 120, 'parameters.order.description')
        val
      end

      def normalize_payment(val)
        return nil if blank?(val)
        raise ArgumentError, 'parameters.payment must be a Hash' unless val.is_a?(Hash)

        status = val[:status]
        ensure_string!(status, 'parameters.payment.status')
        final_status = status.to_s
        unless ALLOWED_PAYMENT_STATUSES.include?(final_status)
          raise ArgumentError, "parameters.payment.status must be one of: #{ALLOWED_PAYMENT_STATUSES.join(', ')}"
        end

        payment = { status: final_status }

        timestamp = val[:timestamp]
        unless blank?(timestamp)
          unless timestamp.is_a?(Integer)
            raise ArgumentError, 'parameters.payment.timestamp must be an Integer (epoch seconds)'
          end
          payment[:timestamp] = timestamp
        end

        payment
      end

      def ensure_string!(val, field_name)
        raise ArgumentError, "#{field_name} must be a String" unless val.is_a?(String)
      end

      def ensure_max_len!(val, max, field_name)
        raise ArgumentError, "#{field_name} must have at most #{max} characters" if val.size > max
      end
    end
  end
end
