# Template

Template messages are used to send a message with a specific template.

This is useful for sending messages that have a predefined structure, such as notifications or alerts.

#### Quick Examples

**Note**: For the examples below, take into account `Warb.setup` was called to configure the global client instance.

List available templates:
```ruby
Warb.template.list
```

Sending template messages:
```ruby
# Send template message (coming soon)
```

#### Listing Templates

**Prerequisites**: In order to view templates, you need to have them available in your business account. For more details, refer to the [Meta documentation](https://developers.facebook.com/docs/whatsapp/cloud-api/guides/send-message-templates/template-library). Template creation via API will be covered later in this documentation (coming soon).

You can retrieve all available message templates:

```ruby
Warb.template.list
```

##### Optional Parameters

You can optionally filter templates using various parameters:

Limit the number of results:
```ruby
Warb.template.list(limit: 10)
```

Specify which template fields to return:
```ruby
Warb.template.list(fields: ["name", "status", "category"])
```

For a complete list of available fields, refer to the [Meta documentation](https://developers.facebook.com/docs/graph-api/reference/whats-app-business-hsm/#fields).

##### Example Response

```ruby
{
  "data" => [
    {
      "name" => "hello_world",
      "status" => "APPROVED",
      "category" => "UTILITY",
      "language" => "en_US",
      "components" => [ ... ],
      "id" => "1282952826730729"
    },
    {
      "name" => "other_template_001",
      "status" => "APPROVED",
      "category" => "MARKETING",
      "language" => "pt_BR",
      "components" => [ ... ],
      "id" => "1948352829250167"
    }
  ],
  "paging" => {
    "cursors" => {
      "before" => "...",
      "after" => "..."
    }
  }
}
```

#### Sending Template Messages

Coming soon