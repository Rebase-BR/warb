# FlowButton

```Warb::Components::FlowButton``` is a component used in template messages for flow buttons.
This button type allows you to link a template directly with a WhatsApp Flow experience.

## Attributes
| Attribute          | Type      | Required | Description                                                     |
| ------------------ | --------- | -------- |-----------------------------------------------------------------|
| `index`            | `Integer` | Yes      | An identifier or position for the button in the template.       |
| `sub_type`         | `String`  | Yes      | Always `"flow"` for this button type.                           |
| `flow_token`       | `String`  | No       | If not set, the API defaults to `"unused"`.                     |
| `flow_action_data` | `Hash`    | No       | A key-value payload passed to the flow as pre-filled form data. |



## Examples
###### Basic Flow button with token
```ruby
flow_button = Warb::Components::FlowButton.new(
  index: 0,
  sub_type: "flow",
  flow_token: "TOKEN_123"
)

flow_button.to_h
=> {
     type: "button",
     sub_type: "flow",
     index: 0,
     parameters: [
       {
         type: "action",
         action: {
           flow_token: "TOKEN_123"
         }
       }
     ]
   }
```

##### Flow button with token and action data
```ruby
flow_button = Warb::Components::FlowButton.new(
  index: 1,
  sub_type: "flow",
  flow_token: "TOKEN_ABC",
  flow_action_data: { name: "John", cpf: "11122233344" }
)

flow_button.to_h
=> {
     type: "button",
     sub_type: "flow",
     index: 1,
     parameters: [
       {
         type: "action",
         action: {
           flow_token: "TOKEN_ABC",
           flow_action_data: { name: "John", cpf: "11122233344" }
         }
       }
     ]
   }
```

##### Flow button without optional fields
```ruby
flow_button = Warb::Components::FlowButton.new(index: 2, sub_type: "flow")
flow_button.to_h
=> {
     type: "button",
     sub_type: "flow",
     index: 2,
     parameters: [
       {
         type: "action",
         action: {}
       }
     ]
   }
```
### Usage in Templates

Flow buttons are typically added to templates using the add_flow_button method:

```ruby
template = Warb::Resources::Template.new(name: "my_template", language: "en_US")

# Add a flow button with token
template.add_flow_button(index: 0, flow_token: "TOKEN_123")

# Add a flow button with token and action data
template.add_flow_button(index: 1, flow_token: "TOKEN_ABC", flow_action_data: { name: "Jane", dob: "1990-01-01" })

# Or using a block for more complex configuration
template.add_flow_button do |button|
  button.index = 0
  button.flow_token = "TOKEN_DYNAMIC"
  button.flow_action_data = { email: "user@example.com" }
end
```