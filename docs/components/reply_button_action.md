# Interactive Reply Button Action

An interactive reply button action allows you to create a set of buttons that, when clicked, send a predefined reply back to the sender.

You don't need to create the buttons manually, as the `Warb::Resources::InteractiveReplyButton` class provides a convenient way to build the action with the buttons texts.

The only `parameter` possible to be set is `buttons_texts`, which is an array of strings representing the texts for each button:

```ruby
action = Warb::Components::ReplyButtonAction.new(buttons_texts: ["Português", "English", "Español"])
```

and could be used like this:

```ruby
Warb.interactive_reply_button.dispatch(recipient_number, action: action) do |message|
  # Set the header, body, and footer as needed
end
```

Check the [Interactive Reply Button Message](../messages/interactive_reply_button.md) documentation for more details on how to use this action in a message.