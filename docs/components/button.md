# Button

`Warb::Components::Button` is a component that represents a generic button used in template messages. It's part of the Components module, which contains reusable parts of complex structures.

It represents a generic button, which can be set with the following attributes:

## Attributes
|   Attribute  |    Type   | Required |                   Description                 |
|--------------|-----------|----------|-----------------------------------------------|
| `index`      | `Integer` |   Yes    | An identifier or position for the button.     |
| `sub_type`   | `String`  |   Yes    | A more specific classification for the button |

## Common Button Types
| Button Type   | Template Instance Method     | Params                  |
|---------------|------------------------------|-------------------------|
| `quick_reply` | `add_quick_reply_button`     | `index`                 |
| `voice_call`  | `add_voice_call_button`      | `index`                 |
| `url`         | `add_dynamic_url_button`     | `index`, `text`         |
| `copy_code`   | `add_copy_code_button`       | `index`, `coupon_code`  |

Please, refer to our [templates messaging documentation](../messages/template.md) for more info. You can check the methods to insert a button in the "Adding Buttons" section.

## Examples

### Quick Reply button
```ruby
quick_reply = Warb::Components::Button.new(index: 0, sub_type: "quick_reply")
quick_reply.to_h
=> {
     type: "button",
     sub_type: "quick_reply",
     index: 0
   }
```

### Voice Call button
```ruby
voice_call = Warb::Components::Button.new(index: 1, sub_type: "voice_call")
voice_call.to_h
=> {
     type: "button",
     sub_type: "voice_call",
     index: 1
   }
```

## Usage in Templates

Buttons are typically used within template messages. Here's how to add them:

```ruby
template = Warb::Resources::Template.new(name: "my_template", language: "en_US")

# Add a quick reply button
template.add_quick_reply_button(index: 0)

# Add a voice call button
template.add_voice_call_button(index: 1)

# The buttons will be included in the template's build_payload (as components)
```
