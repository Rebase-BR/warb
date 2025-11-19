# frozen_string_literal: true

module Warb
  module Resources
    class OrderDetails < Resource
      include Helpers::Header

      attr_accessor :header, :body, :footer,
                    :reference_id, :type, :beneficiaries,
                    :currency, :total_amount,
                    :status, :expiration, :items, :subtotal, :tax, :shipping, :discount,
                    :payment_settings, :catalog_id

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
          type: 'order_details',
          action: {
            name: 'review_and_pay',
            parameters: build_action_parameters
          }
        }

        header = resolve(:header)
        if header.is_a?(Hash)
          interactive[:header] = header
        elsif header.respond_to?(:build_header)
          interactive[:header] = header.build_header
        end

        interactive[:body] = { text: resolve(:body) }

        footer = resolve(:footer)
        interactive[:footer] = { text: footer } unless blank?(footer)

        interactive
      end

      def build_action_parameters
        params = {}
        params[:reference_id] = resolve(:reference_id)
        params[:type]         = final_type
        params[:payment_type] = 'br'
        params[:currency]     = 'BRL'

        bens = normalize_beneficiaries(resolve(:beneficiaries))
        params[:beneficiaries] = bens unless bens.nil?

        params[:total_amount] = amount_object!(resolve(:total_amount), field: 'total_amount')

        params[:order] = order_payload

        params[:payment_settings] = normalize_payment_settings(resolve(:payment_settings))

        params
      end

      def order_payload
        order = {}

        cid = resolve(:catalog_id)
        order[:catalog_id] = cid unless blank?(cid)

        order[:status] = 'pending'

        exp = normalize_expiration(resolve(:expiration))
        order[:expiration] = exp unless exp.nil?

        its = normalize_items(resolve(:items))
        order[:items] = its

        st = amount_object!(resolve(:subtotal), field: 'subtotal')
        order[:subtotal] = st

        tx = amount_with_description_object!(resolve(:tax), field: 'tax', default_zero: true)
        order[:tax] = tx

        shp = amount_with_description_object!(resolve(:shipping), field: 'shipping', default_zero: true)
        order[:shipping] = shp

        dsc = discount_object!(resolve(:discount))
        order[:discount] = dsc unless dsc.nil?

        validate_subtotal_vs_items!(subtotal: st, items: its)
        validate_total_amount_vs_parts!(total_amount: resolve(:total_amount), subtotal: st, tax: tx, shipping: shp, discount: dsc)

        order
      end

      def final_type
        explicit = raw_value(:type)
        return 'digital-goods' if blank?(explicit)

        type = explicit.to_s
        unless %w[digital-goods physical-goods].include?(type)
          raise ArgumentError, "type must be 'digital-goods' or 'physical-goods'"
        end
        type
      end

      def validate!
        validates :body,            required: true
        validates :reference_id,    required: true
        validates :items,           required: true
        validates :subtotal,        required: true
        validates :total_amount,    required: true
        validates :payment_settings, required: true

        validates :beneficiaries, required: -> { final_type == 'physical-goods' }
      end

      def amount_object!(val, field:)
        value = extract_amount_value!(val, field:)
        { value: value, offset: 100 }
      end

      def amount_with_description_object!(val, field:, default_zero: false)
        if blank?(val) && default_zero
          return { value: 0, offset: 100 }
        end
        value = extract_amount_value!(val, field:)
        amount_with_description = { value: value, offset: 100 }

        description = val.is_a?(Hash) ? val[:description] : nil
        unless blank?(description)
          ensure_string!(description, "#{field}.description")
          ensure_max_len!(description, 60, "#{field}.description")
          amount_with_description[:description] = description
        end

        amount_with_description
      end

      def discount_object!(val)
        return nil if blank?(val)

        value = extract_amount_value!(val, field: 'discount')
        discount = { value: value, offset: 100 }

        desc = val[:description] if val.is_a?(Hash)
        unless blank?(desc)
          ensure_string!(desc, 'discount.description')
          ensure_max_len!(desc, 60, 'discount.description')
          discount[:description] = desc
        end

        prog = val[:discount_program_name] if val.is_a?(Hash)
        unless blank?(prog)
          ensure_string!(prog, 'discount.discount_program_name')
          ensure_max_len!(prog, 60, 'discount.discount_program_name')
          discount[:discount_program_name] = prog
        end

        discount
      end

      def extract_amount_value!(val, field:)
        if val.is_a?(Integer)
          return val if val >= 0
          raise ArgumentError, "#{field}.value must be a non-negative integer (in cents)"
        end

        if val.is_a?(Hash)
          v = val[:value]
          raise ArgumentError, "#{field}.value is required" if v.nil?
          raise ArgumentError, "#{field}.value must be an Integer" unless v.is_a?(Integer)
          raise ArgumentError, "#{field}.value must be >= 0" if v < 0
          return v
        end

        raise ArgumentError, "#{field} must be an Integer (cents) or a Hash with :value"
      end

      def normalize_expiration(val)
        return nil if blank?(val)

        raise ArgumentError, 'expiration must be a Hash' unless val.is_a?(Hash)

        ts = val[:timestamp]
        desc = val[:description]

        raise ArgumentError, 'expiration.timestamp is required' if blank?(ts)
        ensure_string!(ts, 'expiration.timestamp')

        raise ArgumentError, 'expiration.description is required' if blank?(desc)
        ensure_string!(desc, 'expiration.description')
        ensure_max_len!(desc, 120, 'expiration.description')

        { timestamp: ts, description: desc }
      end

      def normalize_beneficiaries(val)
        return nil if final_type == 'digital-goods'
        raise ArgumentError, 'beneficiaries must be a non-empty array' unless val.is_a?(Array) && !val.empty?
        val.each do |b|
          raise ArgumentError, 'each beneficiary must be a Hash' unless b.is_a?(Hash)
        end
        val
      end

      def normalize_items(list)
        unless list.is_a?(Array) && !list.empty?
          raise ArgumentError, 'items must be a non-empty array'
        end

        list.map do |it|
          raise ArgumentError, 'each item must be a Hash' unless it.is_a?(Hash)

          retailer_id = it[:retailer_id]
          name        = it[:name]
          amount      = it[:amount]
          quantity    = it[:quantity]

          raise ArgumentError, 'item.retailer_id is required' if blank?(retailer_id)
          ensure_string!(retailer_id, 'item.retailer_id')

          raise ArgumentError, 'item.name is required' if blank?(name)
          ensure_string!(name, 'item.name')
          ensure_max_len!(name, 60, 'item.name')

          raise ArgumentError, 'item.amount is required' if blank?(amount)
          amt = amount_object!(amount, field: 'item.amount')

          raise ArgumentError, 'item.quantity is required' if quantity.nil?
          raise ArgumentError, 'item.quantity must be an Integer' unless quantity.is_a?(Integer)
          raise ArgumentError, 'item.quantity must be >= 1' if quantity < 1

          items = {
            retailer_id: retailer_id,
            name:        name,
            amount:      amt,
            quantity:    quantity
          }

          if it.key?(:sale_amount) && !blank?(it[:sale_amount])
            items[:sale_amount] = amount_object!(it[:sale_amount], field: 'item.sale_amount')
          end

          items[:catalog_id]        = it[:catalog_id]        unless blank?(it[:catalog_id])
          items[:country_of_origin] = it[:country_of_origin] unless blank?(it[:country_of_origin])
          items[:importer_name]     = it[:importer_name]     unless blank?(it[:importer_name])
          items[:importer_address]  = it[:importer_address]  unless blank?(it[:importer_address])

          items
        end
      end

      def validate_subtotal_vs_items!(subtotal:, items:)
        expected = items.sum do |it|
          unit_value = (it[:sale_amount] || it[:amount])[:value]
          unit_value * it[:quantity]
        end

        if subtotal[:value] != expected
          raise ArgumentError,
                "subtotal.value must equal to sale_amount.value or amount.value * quantity; expected #{expected}, got #{subtotal[:value]}"
        end
      end

      def validate_total_amount_vs_parts!(total_amount:, subtotal:, tax:, shipping:, discount:)
        total_amount_value = amount_object!(total_amount, field: 'total_amount')[:value]
        discount_value = discount && discount[:value] ? discount[:value] : 0
        expected = subtotal[:value] + tax[:value] + shipping[:value] - discount_value

        if total_amount_value != expected
          raise ArgumentError,
                "total_amount.value must equal subtotal.value + tax.value + shipping.value - discount.value; expected #{expected}, got #{total_amount_value}"
        end
      end

      def normalize_payment_settings(list)
        unless list.is_a?(Array) && !list.empty?
          raise ArgumentError, 'payment_settings must be a non-empty array'
        end

        allowed_pix_key_types = %w[CPF CNPJ EMAIL PHONE EVP]

        list.map do |payment|
          raise ArgumentError, 'each payment setting must be a Hash' unless payment.is_a?(Hash)
          type = payment[:type].to_s
          raise ArgumentError, 'payment setting :type is required' if blank?(t)

          case type
          when 'pix_dynamic_code'
            data = payment[:pix_dynamic_code]
            raise ArgumentError, 'pix_dynamic_code hash is required' unless data.is_a?(Hash)

            %i[code key key_type merchant_name].each do |k|
              val = data[k]
              raise ArgumentError, "pix_dynamic_code.#{k} is required" if blank?(val)
              ensure_string!(val, "pix_dynamic_code.#{k}")
            end

            key_type = data[:key_type].to_s
            unless allowed_pix_key_types.include?(key_type)
              raise ArgumentError, "pix_dynamic_code.key_type must be one of #{allowed_pix_key_types.join(', ')}"
            end

            {
              type: 'pix_dynamic_code',
              pix_dynamic_code: {
                code:          data[:code],
                key:           data[:key],
                key_type:      key_type,
                merchant_name: data[:merchant_name]
              }
            }

          when 'boleto'
            data = payment[:boleto]
            raise ArgumentError, 'boleto hash is required' unless data.is_a?(Hash)

            digitable = data[:digitable_line]
            raise ArgumentError, 'boleto.digitable_line is required' if blank?(digitable)
            ensure_string!(digitable, 'boleto.digitable_line')

            {
              type: 'boleto',
              boleto: {
                digitable_line: digitable
              }
            }

          when 'payment_link'
            data = payment[:payment_link]
            raise ArgumentError, 'payment_link hash is required' unless data.is_a?(Hash)

            uri = data[:uri]
            raise ArgumentError, 'payment_link.uri is required' if blank?(uri)
            ensure_string!(uri, 'payment_link.uri')

            {
              type: 'payment_link',
              payment_link: {
                uri: uri
              }
            }

          when 'offsite_card_pay'
            data = payment[:offsite_card_pay]
            raise ArgumentError, 'offsite_card_pay hash is required' unless data.is_a?(Hash)

            last4 = data[:last_four_digits]
            cred  = data[:credential_id]

            raise ArgumentError, 'offsite_card_pay.last_four_digits is required' if blank?(last4)
            raise ArgumentError, 'offsite_card_pay.credential_id is required'   if blank?(cred)

            ensure_string!(last4, 'offsite_card_pay.last_four_digits')
            ensure_string!(cred,  'offsite_card_pay.credential_id')

            raise ArgumentError, 'offsite_card_pay.last_four_digits must be 4 digits' unless last4.match?(/\A\d{4}\z/)

            {
              type: 'offsite_card_pay',
              offsite_card_pay: {
                last_four_digits: last4,
                credential_id:    cred
              }
            }

          else
            raise ArgumentError, "unsupported payment setting type: #{type}"
          end
        end
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
