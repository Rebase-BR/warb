# Name

Name, `Warb::Components::Name`, is a component used in the `Contact` message type.

It represents a name with the following fields:

|Attribute         | Type     | Description                                            | Required |
|------------------|----------|--------------------------------------------------------|----------|
| `prefix`         | `String` | The prefix used to address the person                  | *No      |
| `formatted_name` | `String` | The formatted name to be displayed in the contact info | Yes      |
| `first_name`     | `String` | The contact's first name                               | *No      |
| `middle_name`    | `String` | The contact's middle name                              | *No      |
| `last_name`      | `String` | The contact's last name                                | *No      |
| `suffix`         | `String` | The contact's suffix, if applicable                    | *No      |

**Note**: At least one other attribute **must be provided** along with `formatted_name`.

When using the `Warb::Components::Name` component directly, you can set these attributes in the initializer or by assigning them directly to the instance.

```ruby
name = Warb::Components::Name.new(
  formatted_name: "John Doe",
  prefix: "Mr",
  first_name: "John",
  last_name: "Doe"
)
```
or

```ruby
name = Warb::Components::Name.new
name.formatted_name = "John Doe"
name.prefix = "Mr"
name.first_name = "John"
name.last_name = "Doe"
```

But it is better to use it in the context of a `Contact` message type, where you can build the name using the `build_name` method:

```ruby
Warb.contact.dispatch(recipient_number) do |contact|
  contact.build_name do |name|
    name.formatted_name = "John Doe"
    name.prefix = "Mr"
    name.first_name = "John"
    name.last_name = "Doe"
  end
end
```
