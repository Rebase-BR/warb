# Contact

Send a contact using the `contact` wrapper:

```ruby
recipient_number = "..."
Warb.contact.dispatch(recipient_number, ...)
```

**Note**: For the examples below, take into account `Warb.setup` was called to configure the global client instance, and that the variable `recipient_number` is already set.

You can send a simple contact like this:
```ruby
name = Warb::Components::Name.new formatted_name: "Full Name", preffix: "Mr"

Warb.contact.dispatch(recipient_number, name: name)
```

But it may be tiring writing this all, so the next example bellow shows a different approach to send the same message:

```ruby
Warb.contact.dispatch(recipient_number) do |contact|
  contact.build_name formatted_name: "Full Name", prefix: "Mr"
end
```

This block building strategy can be used to build even larger contacts, for exemple:
```ruby
Warb.contact.dispatch(recipient_number) do |contact|
  contact.build_name formatted_name: "Full Name", prefix: "Mr"

  country = "Country"
  country_code = "Country Code"

  # you can set everything inside the block
  contact.add_address do |address|
    address.street = "First Street"
    address.city = "First City"
    address.state = "First State"
    address.zip = "First ZIP"
    address.country = country
    address.country_code = country_code
    address.type = "HOME"
  end

  # you can, as well, pass some values to the add_address method
  second_address = contact.add_address(type: "WORK") do |address|
    address.street = "Second Street"
    address.city = "Second City"
    address.state = "Second State"
    address.zip = "Second ZIP"
  end

  # and also, assign values using the returned object
  second_address.country = country
  second_address.country_code = country_code
end
```

There are more fields which can be set in the contact type message. Here is a more complete example:

```ruby
Warb.contact.dispatch(recipient_number) do |contact|
  # name (a Warb::Components::Name instance)
  contact.build_name do |name|
    name.formatted_name = "Full Name"
    name.prefix = "Mr"
    name.suffix = "IV"
    name.first_name = "Full"
    name.last_name = "Name"
    name.middle_name = "Middle"
  end

  # string in the format YYYY-MM-DD
  contact.birthday = "1980-06-06"

  # addresses (a list of Warb::Components::Address)
  country = "Country"
  country_code = "Country Code"

  contact.add_address do |address|
    address.street = "First Street"
    address.city = "First City"
    address.state = "First State"
    address.zip = "First ZIP"
    address.country = country
    address.country_code = country_code
    address.type = "HOME"
  end

  contact.add_address do |address|
    address.street = "Second Street"
    address.city = "Second City"
    address.state = "Second State"
    address.zip = "Second ZIP"
    address.country = country
    address.country_code = country_code
    address.type = "WORK"
  end

  # emails (a list of Warb::Components::Email)
  contact.add_email(email: "personal@email.com", type: "HOME")
  contact.add_email(email: "work@email.com", type: "WORK")

  # urls (a list of Warb::Components::URL)
  contact.add_url(type: "HOME", url: "https://primary.home.example.com")
  contact.add_url(type: "HOME", url: "https://secondary.home.example.com")
  contact.add_url(type: "WORK", url: "https://work.example.com")

  # phones (a list of Warb::Components::Phone)
  contact.add_phone(type: "HOME", phone: "...")
  contact.add_phone(type: "HOME", phone: "...", wa_id: "...")
  contact.add_phone(type: "WORK", phone: "...")

  # org (a Warb::Components::Org instance)
  contact.build_org do |org|
    org.company = "Inc"
    org.title = "Manager"
    org.department = "IT"
  end
end
```

Here are the specific params which can be passed to the `dispatch` method using the `contact` wrapper:

| Field       | Type / Description                               | Required | Documentation                       |
| ----------- | ------------------------------------------------ | -------- | ----------------------------------- |
| `name`      | A `Warb::Components::Name` instance              | YES      | [Name](../components/name.md)       |
| `birthday`  | A `String` in the format `YYYY-MM-DD`.           | NO       | —                                   |
| `org`       | A `Warb::Components::Org` instance               | NO       | [Org](../components/org.md)         |
| `addresses` | A list of `Warb::Components::Address` instances  | NO       | [Address](../components/address.md) |
| `emails`    | A list of `Warb::Components::Email` instances    | NO       | [Email](../components/email.md)     |
| `urls`      | A list of `Warb::Components::URL` instances      | NO       | [URL](../components/url.md)         |
| `phones`    | A list of `Warb::Components::Phone` instances    | NO       | [Phone](../components/phone.md)     |
