# Address

Address, `Warb::Components::Address`, is a component used in the `Contact` message type.

It represents an address with the following fields:

|Attribute       | Type     | Description                                     | Required |
|----------------|----------|-------------------------------------------------|----------|
| `street`       | `String` | The street address                              | No       |
| `city`         | `String` | The city of the address                         | No       |
| `state`        | `String` | The state of the address                        | No       |
| `zip`          | `String` | The ZIP code of the address                     | No       |
| `country`      | `String` | The country of the address                      | No       |
| `country_code` | `String` | The country code of the address                 | No       |
| `type`         | `String` | The type of the address (e.g., "HOME", "WORK" ) | No       |

When using the `Warb::Components::Address` component directly, you can set these attributes in the initializer or by assigning them directly to the instance.

```ruby
address = Warb::Components::Address.new(
  street: "123 Main St",
  city: "Springfield",
  state: "IL",
  zip: "62701",
  country: "USA",
  country_code: "US",
  type: "HOME"
)
```

or

```ruby
address = Warb::Components::Address.new
address.street = "123 Main St"
address.city = "Springfield"
address.state = "IL"
address.zip = "62701"
address.country = "USA"
```

But is better to use it in the context of a `Contact` message type, where you can add addresses using the `add_address` method:

```ruby
Warb.contact.dispatch(recipient_number) do |contact|
  # Adding an address using a block
  contact.add_address do |address|
    address.street = "123 Main St"
    address.city = "Springfield"
    address.state = "IL"
    address.zip = "62701"
    address.country = "USA"
    address.country_code = "US"
    address.type = "HOME"
  end

  # Adding an address with parameters
  contact.add_address(
    street: "456 Elm St",
    city: "Shelbyville",
    state: "IL",
    zip: "62565",
    country: "USA",
    country_code: "US",
    type: "WORK"
  )
end
```