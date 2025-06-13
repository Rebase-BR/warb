# Text

Send a simple text message using the `text` wrapper:

```ruby
recipient_number = "..."
Warb.message.dispatch(recipient_number, ...)
```

**Note**: For the examples below, take into account `Warb.setup` was called to configure the global client instance, and that the variable `recipient_number` is already set.

You can send a simple text message like this:

```ruby
Warb.message.dispatch(recipient_number, content: "Hello, World!")
```

You can also use the block building strategy to send a text message:

```ruby
Warb.message.dispatch(recipient_number) do |text|
  text.content = "Hey, check this out! https://www.google.com"
  text.preview_url = true
end
```

> If `preview_url` is set to `true`, the recipient WhatsApp phone/computer will try to generate a preview for the URL in the content.

| Field         | Type    | Description                                                                 | Required                                 |
|---------------|---------|-----------------------------------------------------------------------------|------------------------------------------|
| `preview_url` | Boolean | Whether to generate a preview for URLs in the content. Defaults to `false`. | No                                       |
| `content`     | String  | The text content of the message.                                            | Yes *                                      |
| `text`        | String  | The text content of the message.                                            | Yes *                                      |
| `message`     | String  | The text content of the message.                                            | Yes *                                      |

> `content`, `text`, and `message` are interchangeable, you can use any of them to set the text content of the message.
> But if using multiple of them, the priority is: `content` > `text` > `message`.

Also, remember that you can use `reply_to` to reply to a previous message:

```ruby
Warb.message.dispatch(recipient_number, content: "Hello, World!", reply_to: "message_id")
```

Since text messages are the most common to be sent as replies, we're reforcing the use of `reply_to` here in the `text` wrapper. But keep in mind it can used for any other message type, like `image`, `video`, `document`, etc.

**Remember**: it is a param for the `dispatch` method, not a field of the message itself.