# Messaging

To send any message, you can simply call `.dispatch` from either `Warb` module or any `Warb::Client` instance (please, check the [setup](./setup.md) page for more info on how to setup your client), using the corresponding wrapper for the [message type](#messages-types) you want to send:

## General Usage

Basically, you can send any type of message in the same way as bellow, changing the specific params:

```ruby
Warb.<type_of_message_you_want_to_send>.dispatch(<recipient_number>, reply_to: <message_id>, **specific_params)
```

Here is what  you need to do:
- replace `<type_of_message_you_want_to_send>` with the appropriate wrapper based on the type of message you want to send
- replace `<recipient_number>` with the phone number of the intended recipient
- optionally replace `<message_id>` with the ID of a previous message in the conversation if you want to send a reply to that message
  - if you're not replying to a message, you can either set the `reply_to` parameter to `nil` or omit it entirely — `nil` is the default value

Except for the `reply_to` parameter, you can pass any additional named parameters that are specific to the type of message you are sending.

Such parameters are described in the documentation for each message type, which you can find in the [Messages Types](#messages-types) section below.

For instance, to send a simple text message, you can:

**Note**: Assume `Warb.setup` has already been called and the variable `recipient_number` is defined

```ruby
Warb.message.dispatch(recipient_number, text: "Hello from warb")
```

You can also pass a block to `.dispatch` to build the message:

```ruby
Warb.message.dispatch(recipient_number) do |message|
  message.text = "Hello from warb"
end
```
> In the example above, the variable `message` used in the block is an instance of `Warb::Resources::Text`

Under the hood, the `.dispatch` method will:
- create a message resource object, based on the used wrapper
- set its attributes based on the parameters you provide
- call its `build_payload` method to prepare the message for sending
- and finally, send the message

Inside the given block, you can modify modify the message before it's sent.

While using a block just to set a single attribute may seem excessive — it becomes quite useful when dealing with more complex message types, such as contact or interactive messages.

## Messages Types

Messages are sent using a helper dispatcher and its resource class. Here is a list of available message types, their corresponding resource classes, and dispatch wrappers:

| Message Type                   | Resource Class                                | Dispatch Wrapper                    | Documentation                                                                 |
|--------------------------------|-----------------------------------------------|-------------------------------------|-------------------------------------------------------------------------------|
| Simple Dispatchers                                                                                                                                                                                   |
| Contact                        | `Warb::Resources::Contact`                    | `contact`                           | [Contact Message](./contact.md)                                               |
| Interactive Call to Action URL | `Warb::Resources::InteractiveCalltoActionURL` | `interactive_call_to_action_url`    | [Interactive Call to Action URL Message](./interactive_call_to_action_url.md) |
| Interactive List               | `Warb::Resources::InteractiveList`            | `interactive_list`                  | [Interactive List Message](./interactive_list.md)                             |
| Interactive Reply Button       | `Warb::Resources::InteractiveReplyButton`     | `interactive_reply_button`          | [Interactive Reply Button Message](./interactive_reply_button.md)             |
| Flow                           | `Warb::Resources::Flow`                       | `flow`                              | [Flow](./flow.md)                                                             |
| Location                       | `Warb::Resources::Location`                   | `location`                          | [Location Message](./location.md)                                             |
| Location Request               | `Warb::Resources::LocationRequest`            | `location_request`                  | [Location Request Message](./location_request.md)                             |
| Reaction                       | `Warb::Resources::Reaction`                   | `reaction`                          | [Reaction Message](./reaction.md)                                             |
| Text                           | `Warb::Resources::Text`                       | `message`                           | [Text Message](./text.md)                                                     |
| Media Dispatchers                                                                                                                                                                                    |
| Audio                          | `Warb::Resources::Audio`                      | `audio`                             | [Audio Message](./audio.md)                                                   |
| Document                       | `Warb::Resources::Document`                   | `document`                          | [Document Message](./document.md)                                             |
| Image                          | `Warb::Resources::Image`                      | `image`                             | [Image Message](./image.md)                                                   |
| Sticker                        | `Warb::Resources::Sticker`                    | `sticker`                           | [Sticker Message](./sticker.md)                                               |
| Video                          | `Warb::Resources::Video`                      | `video`                             | [Video Message](./video.md)                                                   |
| Special Dispatchers                                                                                                                                                                                  |
| Indicator                      | `Warb::Resources::Indicator`                  | `indicator`                         | [Indicator Message](./indicator.md)                                           |
| Template                       | `Warb::Resources::Template`                   | `template`                          | [Template Message](./template.md)                                             |

> Simple Dispatcher doesn't offer any additional functionality, they just send messages.

> Media Dispatchers, aside from sending messages, also provide methods to upload and download media files.

> Special Dispatchers are used for specific purposes, such as sending indicators or reactions.