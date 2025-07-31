# Button

`Warb::Resources::Button` is a resource, but different from most other resources, it can't be sent. Instead, it's used in a template message as one of its parameters.

It represents a generic button, which can be set with the following attributes:

## Attributes
|   Attribute  |    Type   | Required |                   Description                 |
|--------------|-----------|----------|-----------------------------------------------|
| `index`      | `Integer` |   Yes    | An identifier or position for the button.     |
| `sub_type`   | `String`  |   Yes    | A more specific classification for the button |

## Common Button Types
| Button Type   | Template Instance Method     | Params                  |
|---------------|------------------------------|-------------------------|
| `quick_reply` | `set_quick_reply_button`     | `index`                 |
| `voice_call`  | `set_voice_call_button`      | `index`                 |
| `url`         | `set_dynamic_url_button`     | `index`, `text`         |
| `copy_code`   | `set_copy_code_button`       | `index`, `coupon_code`  |

Please, refer to  our [templates messaging documentation](../messages/template.md) for more info. You can check the methods to insert a button in the "Adding Buttons" section.

## Examples

### Quick Reply button
```ruby
quick_reply = Warb::Resources::Button.new(index: 0, sub_type: "quick_reply")
quick_reply.build_payload
=> {
     type: "button",
     sub_type: "quick_reply",
     index: 0
   }
```
