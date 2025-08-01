# UrlButton

`Warb::Components::UrlButton` is a component used in template messages, for dynamic url or auth code buttons.

## Attributes
|   Attribute  |    Type   | Required |                   Description                 |
|--------------|-----------|----------|-----------------------------------------------|
| `index`      | `Integer` |   Yes    | An identifier or position for the button.     |
| `sub_type`   | `String`  |   Yes    | Always "url" for this button type             |
| `text`       | `String`  |   No     | The URL suffix or text parameter for the button |

## Examples

### Basic URL button
```ruby
url_button = Warb::Components::UrlButton.new(index: 0, sub_type: "url", text: "example.com")
url_button.to_h
=> {
     type: "button",
     sub_type: "url",
     index: 0,
     parameters: [
       {
         type: "text",
         text: "example.com"
       }
     ]
   }
```

### URL button without text parameter
```ruby
url_button = Warb::Components::UrlButton.new(index: 1, sub_type: "url")
url_button.to_h
=> {
     type: "button",
     sub_type: "url",
     index: 1
   }
```

## Usage in Templates

URL buttons are typically added to templates using the `add_dynamic_url_button` method:

```ruby
template = Warb::Resources::Template.new(name: "my_template", language: "en_US")

# Add a dynamic URL button
template.add_dynamic_url_button(index: 0, text: "example.com")

# Or using a block for more complex configuration
template.add_dynamic_url_button do |button|
  button.index = 0
  button.text = "example.com"
end
```
