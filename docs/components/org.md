# Org

Org, `Warb::Components::Org`, is a component used in the `Contact` message type.

It represents an Organization with the following fields:

|Attribute       | Type     | Description                                   | Required |
|----------------|----------|-----------------------------------------------|----------|
| `company`      | `String` | Name of the company where the contact works   | No       |
| `title`        | `String` | Contact's job title                           | No       |
| `department`   | `String` | Department within the company                 | No       |

When using the `Warb::Components::Org` component directly, you can set these attributes in the initializer or by assigning them directly to the instance.

```ruby
org = Warb::Components::Org.new(
  company: "Example Corp",
  title: "Software Engineer",
  department: "Engineering"
)
```

or

```ruby
org = Warb::Components::Org.new
org.company = "Example Corp"
org.title = "Software Engineer"
org.department = "Engineering"
```

But it is better to use it in the context of a `Contact` message type, where you can build the organization using the `build_org` method:

```ruby
Warb.contact.dispatch(recipient_number) do |contact|
  contact.build_org do |org|
    org.company = "Example Corp"
    org.title = "Software Engineer"
    org.department = "Engineering"
  end
end
```