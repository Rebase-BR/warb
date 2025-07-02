# Flow

Flow is a special type of message. We can summarize it simply as a form.

At this point of writing, this gem only supports sending existing flows, and it can only send flows which are in draft.

To send flows, you can do as following:
```ruby
Warb.flow.dispatch(recipient_number, flow_id: "flow_id", screen: "screen")
```

`flow_id` must be the ID of the flow and `screen` must be the ID of the first screen of the flow.