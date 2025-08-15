# frozen_string_literal: true

RSpec.describe Warb::Resources::Contact do
  subject { build :contact }

  describe '#add_address' do
    it do
      expect { subject.add_address }.to change(subject.addresses, :count).by(1)
    end

    it do
      expect(subject.add_address).to be_a Warb::Components::Address
    end

    it do
      address = subject.add_address type: 'WORK', state: 'ST'
      address.country_code = 'CC'
      address.country = 'C'

      expect(address.to_h).to eq(
        {
          type: 'WORK', state: 'ST', country_code: 'CC', country: 'C',
          city: nil, zip: nil, street: nil
        }
      )
    end

    it do
      address = subject.add_address do |address|
        expect(address).to be_a Warb::Components::Address
      end

      expect(address).to eq subject.addresses.last
    end
  end

  describe '#add_email' do
    it do
      expect { subject.add_email }.to change(subject.emails, :count).by(1)
    end

    it do
      expect(subject.add_email).to be_a Warb::Components::Email
    end

    it do
      email = subject.add_email email: 'email@example.com'
      email.type = 'WORK'

      expect(email.to_h).to eq({ type: 'WORK', email: 'email@example.com' })
    end

    it do
      email = subject.add_email do |email|
        email.type = 'WORK'
        expect(email).to be_a Warb::Components::Email
      end

      expect(email.type).to eq 'WORK'
      expect(email).to eq subject.emails.last
    end
  end

  describe '#add_phone' do
    it do
      expect { subject.add_phone }.to change(subject.phones, :count).by(1)
    end

    it do
      expect(subject.add_phone).to be_a Warb::Components::Phone
    end

    it do
      phone = subject.add_phone
      phone.type = 'WORK'
      phone.phone = '+5522...'

      expect(phone.to_h).to eq({ type: 'WORK', phone: '+5522...', wa_id: nil })
    end

    it do
      phone = subject.add_phone do |phone|
        phone.type = 'WORK'
        expect(phone).to be_a Warb::Components::Phone
      end

      expect(phone.type).to eq 'WORK'
      expect(phone).to eq subject.phones.last
    end
  end

  describe '#add_url' do
    it do
      expect { subject.add_url }.to change(subject.urls, :count).by(1)
    end

    it do
      expect(subject.add_url).to be_a Warb::Components::URL
    end

    it do
      url = subject.add_url url: 'example.com'

      expect(url.to_h).to eq({ type: nil, url: 'example.com' })
    end

    it do
      url = subject.add_url do |url|
        url.type = 'HOME'
        expect(url).to be_a Warb::Components::URL
      end

      expect(url.type).to eq 'HOME'
      expect(url).to eq subject.urls.last
    end
  end

  describe '#build_name' do
    it do
      name = subject.build_name

      expect(name).to be_a Warb::Components::Name
      expect(subject.name).to eq name
    end

    it do
      name = subject.build_name(first_name: 'first_name') do |name|
        name.formatted_name = 'Full Name'
        expect(name).to be_a Warb::Components::Name
      end

      expect(name.formatted_name).to eq 'Full Name'
      expect(name.first_name).to eq 'first_name'
    end
  end

  describe '#build_org' do
    it do
      org = subject.build_org

      expect(org).to be_a Warb::Components::Org
      expect(subject.org).to eq org
    end

    it do
      org = subject.build_org(title: 'CEO') do |org|
        org.company = 'Inc'
        expect(org).to be_a Warb::Components::Org
      end

      expect(org.company).to eq 'Inc'
      expect(org.title).to eq 'CEO'
    end
  end

  describe '#build_payload' do
    it do
      expect(subject.org).to receive(:to_h)
      expect(subject.name).to receive(:to_h)
      expect(subject.urls.first).to receive(:to_h)
      expect(subject.phones.first).to receive(:to_h)
      expect(subject.emails.first).to receive(:to_h)
      expect(subject.addresses.first).to receive(:to_h)

      contact_payload = subject.build_payload

      expect(contact_payload.keys).to include(:type, :contacts)

      expect(contact_payload[:type]).to eq 'contacts'

      expect(contact_payload[:contacts].first.keys).to include(
        :urls, :emails, :emails, :phones, :addresses, :org, :name, :birthday
      )
    end
  end
end
