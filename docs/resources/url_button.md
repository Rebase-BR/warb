# URL Button

`Warb::Resources::UrlButton` is a resource, but different from most other resources, it can't be sent. Instead, it's used in a template message as one of its parameters.

It represents a url button, which can be set with the following attributes:

## Attributes
|   Attribute  |    Type   | Required |                       Description                       |
|--------------|-----------|----------|---------------------------------------------------------|
| `index`      | `Integer` |   Yes    | An identifier or position for the button.               |
| `sub_type`   | `String`  |   Yes    | Must be `"url"` to represent this kind of button.       |
| `text`       | `String`  |   Yes    | The text payload attached to the button; serialized as a `text` parameter (e.g., a URL). |

Since it is used in a template, you can check the methods to insert a button in the "Adding Buttons" section in our [templates messaging documentation](../messages/template.md) for more info.

## Examples
### with text parameter
```ruby
url_button = Warb::Resources::UrlButton.new(index: 0, sub_type: "url", text: "https://example.com")
url_button.build_payload
=> {
     type: "button",
     sub_type: "url",
     index: 0,
     parameters: [
      {
        type: "text",
        text: "https://example.com" 
      }
     ]
   }
```