# Indicator

The `indicator` dispatcher wrapper is not used to send messages, but rather to indicate that a message is being processed or is in progress.

It can be used to show that the system is working on something, such as processing a request or waiting for a response.

Right now, only two types of indicators are supported: `send_typing_indicator` and `mark_as_read`.

#### Mark as Read

You can mark a message as read like this:

```ruby
Warb.indicator.mark_as_read(message_id)
```

The message ID is the ID of the message you want to mark as read.

Previous messages in the conversation also will be marked as read.

You can get the message ID from the webhook payload when receiving a message.

Check our [`webhook.rb`](../../examples/webhook.rb) example to see how to mark a message as read in your application.

#### Send Typing Indicator

You can send a typing indicator like this:

```ruby
Warb.indicator.send_typing_indicator(message_id)
```

Under the hood, typing indicators are sent in the same way as read indicators, so we need a message ID for that.

Also, that means that the typing indicator will also mark the message as read, so if you're planning to respond imediately, you can simply send the typing indicator and then send the message without worrying about marking it as read.

Also note that the typing indicator will remaing active for, at most, 25 seconds, and will be dismissed when the user sends a message or when the 25 seconds expire.

Anyway, check our [`webhook.rb`](../../examples/webhook.rb) example to see how to send a typing indicator in your application.