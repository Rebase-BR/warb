# Row

Row is a component that represents a single item in a section of an interactive list message. It is used to display an option or choice to the user.

You don't need to create a row by youself, as the `Warb::Components::Section` will handle that for you.

Here are its attributes:
| Attribute   | Type   | Required | Max Length | Description                                                                 |
|-------------|--------|----------|------------|-----------------------------------------------------------------------------|
| title       | String | Yes      | 24         | The title of the row, which is displayed to the user                        |
| description | String | No       | 72         | A brief description of the row, providing additional context or information |

Check its usage in the [section component documentation](./section.md) or a more complete guide in the [interactive list message documentation](../messages/interactive_list.md)