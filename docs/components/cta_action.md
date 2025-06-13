# Call To Action Url Action (CTAAction)

The `CTAAction` component is used to define the action of a call to action URL message.

You don't need to create an instance of `CTAAction` manually, as the `Warb::Resources::InteractiveCalltoActionURL` resource class provides a convenient method to build it, but here are its parameters:
| Attribute     | Type     | Description                                              | Required |
|---------------|----------|----------------------------------------------------------|----------|
| `url`         | `String` | The URL to redirect the user when the button is clicked. | Yes      |
| `button_text` | `String` | The text to display on the button.                       | Yes      |

The `button_text` content must be, at most, 20 characters long.

See its usage in the [Interactive Call to Action URL Message](../messages/interactive_call_to_action_url.md) documentation.