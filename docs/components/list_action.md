# Interactive List Action

The `ListAction` component is used to define the action of an interactive list message.

You don't need to create an instance of `ListAction` manually, as the `Warb::Resources::InteractiveList` resource class provides a convenient method to build it, but here are its parameters:

| Attribute     | Type     | Description                                                                                                          | Required |
|---------------|----------|----------------------------------------------------------------------------------------------------------------------|----------|
| button_text   | String   | The text displayed on the button that the user can click to select an option from the list.                          | Yes      |
| sections      | Array    | An array of [`Warb::Components::Section`](./section.md) instances, each representing a group of options in the list. | Yes      |

The `ListAction` component also provides a `add_section` method to add a section to the action after its creation.

```ruby
action = Warb::Components::ListAction.new(button_text: "Select")
section = action.add_section(title: "Languages") # returns a Warb::Components::Section instance
```

You can also use a block with the `add_section` method to build the section, which is useful for setting its options:

```ruby
action = Warb::Components::ListAction.new(button_text: "Select")
section = action.add_section do |section|
  section.title = "Languages"
  section.add_row(...) # add options here
end
```

Check its complete usage in the [interactive list message documentation](../messages/interactive_list.md).
