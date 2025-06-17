# Section

`Warb::Components::Section` is a component that represents a group of items of an interactive list message. It is used to display multiple options, grouped under a common title.

You don't need to create a section by yourself, as the `Warb::Components::ListAction` will handle that for you.

Here are its attributes:
| Attribute | Type   | Required | Max Length                                             | Description                                    |
|-----------|--------|----------|--------------------------------------------------------|------------------------------------------------|
| title     | String | Yes      | 24                                                     | The title of the section                       |
| rows      | Array  | Yes      | 10 (combining all sections within the message)         | The available options the user can choose from |

The section component instance also offers a `add_row` method to add a row to the section after its creation.

```ruby
section = Warb::Components::Section.new(title: "Languages")

section.add_row(title: "Português")
section.add_row(title: "English")

# or using a block
section.add_row do |row|
  row.title = "Español"
  row.description = "Spanish language"
end
```

Under the hood, it will create a [`Warb::Components::Row`](./row.md) for each item added to the section.

Check its complete usage in the [interactive list message documentation](../messages/interactive_list.md)
