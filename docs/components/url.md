# URL

URL, `Warb::Components::URL`, is a component used in the `Contact` message type.

It represents an Organization with the following fields:

|Attribute | Type     | Description                                                                          | Required |
|----------|----------|--------------------------------------------------------------------------------------|----------|
| `url`    | `String` | Website URL associated with the contact or their company                             | No       |
| `type`   | `String` | Type of website. For example, company, work, personal, Facebook Page, Instagram, etc | No       |

When using the `Warb::Components::URL` component directly, you can set these attributes in the initializer or by assigning them directly to the instance.

```ruby
url = Warb::Components::URL.new(
  url: "https://example.com",
  type: "company"
)
```
or

```ruby
url = Warb::Components::URL.new
url.url = "https://example.com"
url.type = "company"
```
But it is better to use it in the context of a `Contact` message type, where you can build the URL using the `add_url` method:

```ruby
Warb.contact.dispatch(recipient_number) do |contact|
  # Adding a URL using a block
  contact.add_url do |url|
    url.url = "https://example.com"
    url.type = "company"
  end

  # Adding a URL with parameters
  contact.add_url(url: "https://personal.example.com", type: "personal")
end
```