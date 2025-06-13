# Reaction

Reaction messages are used to send reactions to a specific message. They can be used to express emotions or feedback in response to a message.

You can send a reaction message like this:

```ruby
Warb.reaction.dispatch(recipient_number, emoji: "✅", reply_to: "message_id")
```

`emoji` is required, is a string, and can be:
- any emoji supported by Android and iOS devices;
- rendered-emojis, such as `😀`, `🙃` or `✅`;
- unicode values, which must be Java- or JavaScript-escape encoded, such as `\uD83D\uDE00`;
- an empty string to remove a previously sent emoji.

> Since ruby doesn't support unicode escape sequences, it is easier to use rendered emojis option.

As for the `message_id`, it is the ID of the message you want to react to.

You can get this ID from the webhook payload when receiving a message.

Check our [`webhook.rb`](../../examples/webhook.rb) example to see how to react to a message in your application.