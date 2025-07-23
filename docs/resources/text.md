# Text

`Warb::Resources::Text` is a resource, which represents a text.

It can be used as a [simple message](../messages/text.md), as a text header for some interactive messages, like the [reply button message](../messages/interactive_reply_button.md) and as [parameters for templates](../messages/template.md) variables.

In the [text messaging documentation](../messages/text.md) there is a table with the corresponding attributes.

Aside from such attributes, `Text` resource also provides the `build_template_named_parameter` and `build_template_positional_parameter` methods, which are using under the hood for the template messaging feature.