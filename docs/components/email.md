# Email

Email, `Warb::Components::Email`, is a component used in the `Contact` message type.

It represents an email address with the following fields:

|Attribute | Type     | Description                                   | Required |
|----------|----------|-----------------------------------------------|----------|
| `email`  | `String` | The email address                             | No       |
| `type`   | `String` | The type of the email (e.g., "HOME", "WORK" ) | No       |

When using the `Warb::Components::Email` component directly, you can set these attributes in the initializer or by assigning them directly to the instance.

```ruby
address = Warb::Components::Email.new(
  email: "personal@example.com",
  type: "HOME"
)
```
or

```ruby
address = Warb::Components::Email.new(type: "WORK")
address.email = "work@example.com"
```

But is better to use it in the context of a `Contact` message type, where you can add emails using the `add_email` method:

```ruby
Warb.contact.dispatch(recipient_number) do |contact|
  # Adding an email using a block
  contact.add_email do |email|
    email.email = "work@example.com"
    email.type = "WORK"
  end

  # Adding an email with parameters
  contact.add_email(email: "home@example.com", type: "HOME")
end
```