# Copy Code Button

`Warb::Resources::CopyCodeButton` is a resource, but different from most other resources, it can't be sent. Instead, it's used in a template message as one of its parameters.

It represents a copy code button, which can be set with the following attributes:

## Attributes
|   Attribute  |    Type   | Required |                       Description                       |
|--------------|-----------|----------|---------------------------------------------------------|
| `index`      | `Integer` | Yes      | An identifier or position for the button.               |
| `sub_type`   | `String`  | Yes      | Must be `"copy_code"` to represent this kind of button. |
| `coupon_code`| `String`  | Yes      | The coupon/code to be exposed                           |

Since it is used in a template, you can check the methods to insert a button in the "Adding Buttons" section in our [templates messaging documentation](../messages/template.md) for more info.

## Examples
### with coupon code
```ruby
copy_button = Warb::Resources::CopyCodeButton.new(index: 0, sub_type: "copy_code", coupon_code: "SAVE20")
copy_button.build_payload
=> {
     type: "button",
     sub_type: "copy_code",
     index: 0,
     parameters: [
      { 
        type: "coupon_code", 
        coupon_code: "SAVE20" 
      }
     ]
   }
```
