# frozen_string_literal: true

FactoryBot.define do
  factory :contact, class: Warb::Resources::Contact do
    addresses { build_list :address, addresses_count }
    emails { build_list :email, emails_count }
    phones { build_list :phone, phones_count }
    urls { build_list :url, urls_count }
    name { build :name }
    org { build :org }
    birthday { Faker::Date.birthday.to_s }

    transient do
      addresses_count { 1 }
      emails_count { 1 }
      phones_count { 1 }
      urls_count { 1 }
    end
  end
end
