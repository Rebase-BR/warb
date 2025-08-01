# CopyCodeButton

`Warb::Components::CopyCodeButton` is a component used in template messages for copy code buttons.

## Attributes
|   Attribute    |    Type   | Required |                   Description                 |
|----------------|-----------|----------|-----------------------------------------------|
| `index`        | `Integer` |   Yes    | An identifier or position for the button.     |
| `sub_type`     | `String`  |   Yes    | Always "copy_code" for this button type       |
| `coupon_code`  | `String`  |   No     | The coupon code to be copied when button is pressed |

## Examples

### Basic copy code button
```ruby
copy_button = Warb::Components::CopyCodeButton.new(index: 0, sub_type: "copy_code", coupon_code: "SAVE20")
copy_button.to_h
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

### Copy code button without coupon code
```ruby
copy_button = Warb::Components::CopyCodeButton.new(index: 1, sub_type: "copy_code")
copy_button.to_h
=> {
     type: "button",
     sub_type: "copy_code",
     index: 1
   }
```

## Usage in Templates

Copy code buttons are typically added to templates using the `add_copy_code_button` method:

```ruby
template = Warb::Resources::Template.new(name: "my_template", language: "en_US")

# Add a copy code button
template.add_copy_code_button(index: 0, coupon_code: "SAVE20")

# Or using a block for more complex configuration
template.add_copy_code_button do |button|
  button.index = 0
  button.coupon_code = "SAVE20"
end
```
